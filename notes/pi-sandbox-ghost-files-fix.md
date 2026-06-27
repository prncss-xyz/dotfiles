# Plan: Fix pi-sandbox leaving ghost empty files (`.idea`, `.profile`, …)

## TL;DR / Root cause

On Linux, `pi-sandbox` runs every `bash` command inside a bubblewrap (bwrap)
sandbox produced by `@carderne/sandbox-runtime`. To enforce **deny-write on
paths that don't exist yet**, bwrap performs `--ro-bind /dev/null <path>`,
and bwrap **creates an empty file (or empty dir) on the host filesystem** at
that path to act as a mount point. The runtime tracks those created paths and
is designed to delete them right after the wrapped command exits — but only if
the **caller invokes `SandboxManager.cleanupAfterCommand()`** after the child
process finishes.

`pi-sandbox@0.4.3` never calls `cleanupAfterCommand()`. It calls
`SandboxManager.wrapWithSandbox(command)` on every bash invocation and spawns
the result, but the `child.on("close", …)` / `child.on("error", …)` handlers
in `createSandboxedBashOps.exec` only resolve/reject — they do not clean up.

Consequence:

- The runtime's `activeSandboxCount` (incremented once per
  `wrapCommandWithSandboxLinux`) is **never decremented between commands**, so
  per-command cleanup is deferred forever.
- The module-level `bwrapMountPoints` set — and the empty files it points at —
  survives for the whole session. The deny list always includes the runtime's
  dangerous dotfiles, so you reliably get ghost files `.idea` and `.profile`
  (plus `.gitconfig`, `.bashrc`, `.zshrc`, `.gitmodules`, etc. when they don't
  pre-exist) materializing in the working directory.
- The files are only removed at `session_shutdown`, where the plugin calls
  `SandboxManager.reset()` → `cleanupBwrapMountPoints({ force: true })`. If the
  session is killed (SIGKILL / crash) even that safety net is skipped and the
  ghosts persist permanently.

So the user's intuition is correct — a sandbox-library cleanup method is not
being called. But the precise missing call is the **lightweight per-command
`cleanupAfterCommand()`**, _not_ `reset()`. `reset()` is already wired at
session teardown and is far too heavy to call per command (it tears down and
re-creates the HTTP/SOCKS proxy bridges). `cleanupAfterCommand()` is the method
the runtime authors built specifically for this purpose.

## Evidence (installed versions)

`@carderne/sandbox-runtime@0.0.49`, `pi-sandbox@0.4.3`.

1. **Dangerous lists always added as deny paths.**
   `dist/sandbox/sandbox-utils.js`:

   ```js
   export const DANGEROUS_FILES = [
     ".gitconfig",
     ".gitmodules",
     ".bashrc",
     ".bash_profile",
     ".zshrc",
     ".zprofile",
     ".profile",
     ".ripgreprc",
     ".mcp.json",
   ];
   export const DANGEROUS_DIRECTORIES = [".git", ".vscode", ".idea"];
   ```

   `getDangerousDirectories()` returns `['.vscode', '.idea', '.claude/commands',
'.claude/agents']`. These become deny-write targets for every command.

2. **bwrap creates host empty files as mount points for non-existent deny paths.**
   `dist/sandbox/linux-sandbox-utils.js` (~line 576, inside
   `wrapCommandWithSandboxLinux`):

   ```js
   // bwrap creates empty files on the host as mount points for these binds.
   // We track them in bwrapMountPoints so cleanupBwrapMountPoints() can
   // remove them after the command exits.
   if (!fs.existsSync(normalizedPath)) {
     ...
     denyWriteArgs.push('--ro-bind', '/dev/null', firstNonExistent);
     bwrapMountPoints.add(firstNonExistent);
     registerExitCleanupHandler();
   }
   ```

3. **The runtime explicitly says cleanup must run after each command.**
   `dist/sandbox/linux-sandbox-utils.js` (~line 229), on
   `cleanupBwrapMountPoints`:

   > "This should be called after each sandboxed command completes to prevent
   > ghost dotfiles (e.g. .bashrc, .gitconfig) from appearing in the working
   > directory."

4. **`activeSandboxCount` is incremented per wrap and only decremented by
   `cleanupBwrapMountPoints()`.**
   `dist/sandbox/linux-sandbox-utils.js` (~line 247):

   ```js
   export function cleanupBwrapMountPoints(opts) {
     if (!opts?.force) {
       if (activeSandboxCount > 0) activeSandboxCount--;
       if (activeSandboxCount > 0) {
         /* defer */ return;
       }
     } else {
       activeSandboxCount = 0;
     }
     // ...unlink empty mount-point files/dirs...
     bwrapMountPoints.clear();
   }
   ```

   `wrapCommandWithSandboxLinux` increments it (~line 808) and only undoes the
   increment if wrapping itself _throws_ (~line 939). On a successful wrap, the
   decrement is the caller's job via `cleanupAfterCommand()`.

5. **`SandboxManager.cleanupAfterCommand()` is exported and meant for exactly
   this.** `dist/sandbox/sandbox-manager.js`:

   ```js
   function cleanupAfterCommand() { cleanupBwrapMountPoints(); }
   ...
   export const SandboxManager = { ..., cleanupAfterCommand, reset, ... };
   ```

6. **The plugin uses `wrapWithSandbox` but never `cleanupAfterCommand`.**
   `pi-sandbox/index.ts`:

   ```js
   const wrappedCommand = await SandboxManager.wrapWithSandbox(command); // line ~351
   // ... spawn ... child.on("close", ... resolve/reject)  // no cleanupAfterCommand
   ```

   Grep over `index.ts`: `wrapWithSandbox` (line 351) and `reset()` (lines 468,
   994, 1070) are called, but `cleanupAfterCommand` is **never** referenced.

## The fix

Target file: `pi-sandbox/index.ts`, function `createSandboxedBashOps` →
`exec`. Add `SandboxManager.cleanupAfterCommand()` after the spawned child
terminates (close **and** error paths), guarded so a cleanup failure can never
fail the command.

```ts
const wrappedCommand = await SandboxManager.wrapWithSandbox(command);
const { shell, args } = getShellConfig(shellPath);

// Ensure bwrap's empty mount-point files are removed even if this exec
// throws before spawn produces a child.
const cleanup = () => {
  try {
    SandboxManager.cleanupAfterCommand();
  } catch {}
};

return new Promise((resolve, reject) => {
  const child = spawn(shell, [...args, wrappedCommand], {
    /* ... */
  });

  // ... timeout / onData wiring unchanged ...

  child.on("error", (err) => {
    if (timeoutHandle) clearTimeout(timeoutHandle);
    cleanup(); // <-- balance activeSandboxCount
    reject(err);
  });

  // ... onAbort unchanged (kill triggers close, which cleans up) ...

  child.on("close", (code) => {
    if (timeoutHandle) clearTimeout(timeoutHandle);
    signal?.removeEventListener("abort", onAbort);
    cleanup(); // <-- removes ghost .idea/.profile/etc.

    if (signal?.aborted) reject(new Error("aborted"));
    else if (timedOut) reject(new Error(`timeout:${timeout}`));
    else resolve({ exitCode: code });
  });
});
```

Notes:

- Put the call in `close` and `error`, not in `onAbort`: an abort SIGKILLs the
  child, which still emits `close`, so `close` is the single reliable
  "command finished" hook.
- A single `cleanup()` helper keeps every exit path balanced. Forgetting the
  `error` path would leave `activeSandboxCount` stuck high and re-introduce the
  defer-forever bug.
- The `bash.execute` retry path (write-block → grant → `runBash()` again) is
  fine as-is: each `runBash` builds a fresh `createSandboxedBashOps`, so every
  spawned child gets its own wrap and its own cleanup.
- `cleanupAfterCommand()` is a no-op on macOS, so this change is safe across
  platforms; no need to gate on `process.platform`.

## Why NOT `reset()`

`reset()` (`SandboxManager.reset`) does `cleanupBwrapMountPoints({ force: true })`
_plus_ shuts down the log monitor and kills/waits for the HTTP & SOCKS bridge
processes. Re-running that on every command would tear down and require
re-`initialize()`-ing the network bridges constantly — slow and pointless.
`reset()` is correctly used today at `session_shutdown`,
`sandbox-disable`, and before `reinitializeSandbox`. Leave it there; use
`cleanupAfterCommand()` for the per-command case.

## Delivery strategy

The buggy file ships inside an npm package (`pi-sandbox@0.4.3`), so a bare
file edit in `node_modules` will be lost on the next install. Pick one:

1. **Upstream PR (preferred).** `pi-sandbox` is maintained by the same author
   as the runtime (Chris Arderne, github.com/carderne/pi-sandbox). Open an issue
   / PR titled "Call `SandboxManager.cleanupAfterCommand()` after each sandboxed
   bash command to stop ghost dotfiles (.idea/.profile/…)" with the diff above.
   This is a small, clearly-correct fix; the runtime already documents the
   contract.
2. **Local patch until released.** Apply the edit to
   `…/node_modules/pi-sandbox/index.ts` (Pi loads the extension source directly
   via `index.ts`, no build step), and pin via an `overrides`/`patched-package`
   mechanism so reinstall survives. Revisit once an upstream release lands and
   drop the patch.
3. **Upgrade runtime + plugin.** Check npm for newer `pi-sandbox` /
   `@carderne/sandbox-runtime`. (Registry was unreachable in this environment —
   `EROFS` on npm cache — so versions weren't verified here.) If a newer
   pi-sandbox already calls `cleanupAfterCommand`, just bump the version.

Recommended sequence: do (1), apply (2) immediately so the machine stops
littering dotfiles, then remove the local patch once (1) ships.

## Verification

1. **Reproduce before.** In an empty temp dir, run a pi bash command under the
   sandbox and confirm ghost files appear:

   ```sh
   mkdir -p /tmp/sbtest && cd /tmp/sbtest
   # via pi: run `true` (or any command) with the sandbox enabled
   ls -la   # observe empty .idea, .profile, etc. created
   ```

2. **Apply the fix** (local patch).
3. **Verify after.** Repeat step 1; after the command completes, `ls -la`
   must show **no** `.idea`/`.profile`/`.gitconfig`/`.bashrc`/… ghost files.
4. **Multi-command / abort tests.**
   - Run several bash commands in a row → no accumulation; `activeSandboxCount`
     stays balanced (enable `SRT_DEBUG`/runtime debug logging to confirm the
     "Cleaned up bwrap mount point" lines).
   - Abort a long-running command (Ctrl-C) → no leftover files (close still
     fires, cleanup runs).
   - Force-kill the pi session mid-command → ghost files cleaned by the
     process-exit safety net `registerExitCleanupHandler`.
5. **macOS regression check.** `cleanupAfterCommand()` is a no-op there, so
   behaviour is unchanged; run one command to confirm no error is thrown.
6. **Lint/compile.** `cd …/pi-sandbox && npm run check` (tsc --noEmit) and
   `npm run lint`.

## Pitfalls / edge cases to respect

- **Don't call `reset()` per command** (see above) — it would cycle the network
  bridges every command and is symmetrically wrong.
- **Don't gate cleanup with `if (sandboxEnabled)` in `exec`** — `exec` is only
  constructed/reached when the sandbox path is active, but more importantly
  `wrapWithSandbox` already incremented the counter, so the decrement must run
  unconditionally on exit. The `try/catch` around it is enough safety.
- **`bwrapMountPoints` is module-level in the runtime.** It is shared across all
  concurrent wraps; cleanup is intentionally deferred while
  `activeSandboxCount > 0` so that deleting a mount point on the host doesn't
  detach another still-running bwrap's bind mount. Keep calling once per
  command — the runtime's counter handles concurrency correctly; do not attempt
  to manage the set yourself.
- **Empty-dir mount points (Fix 2 in the runtime).** Intermediate non-existent
  path components are mounted as empty dirs (`mkdtempSync(... 'claude-empty-')`),
  not `/dev/null`. `cleanupBwrapMountPoints` handles both shapes; just call it —
  don't add manual `unlink` logic.
- **Real content is preserved.** Cleanup only deletes files that are still
  zero-length / dirs still empty, so a deny path the user legitimately populated
  won't be clobbered. No special handling needed in the plugin.
