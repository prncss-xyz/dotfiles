---
description: Simplify and review an already-implemented task, with a fix loop
---

Act as the parent orchestrator for the post-implementation polish of the task most recently implemented in this conversation. Infer the task's intent from the conversation context — there is no required argument.

Keep all project-file writes single-threaded. Use `async: true` for every subagent launch and use `wait()` when a result is required. Do not finish while a promised simplification, review, or fix run is still active.

Workflow:

1. Confirm there is implemented work to polish: check the working tree and staged diff (`git status`, `git diff`, `git diff --staged`). If nothing has changed since the conversation started, stop and ask the user to point at the work to polish.
2. Summarize the inferred task intent in a few sentences so every downstream subagent can validate findings against it.
3. If implementation surfaced an unresolved product, API, architecture, or scope decision, stop and ask the user before continuing.
4. Launch `simplifier` as the sole writer. Ask it to simplify only the implementation diff against the inferred intent from step 2.
5. Wait for simplification to finish.
6. Run the review/fix loop below for at most four rounds:
   a. Launch these agents in parallel with `context: "fresh"`: `precommit-reviewer`, `quality-reviewer`, `idiomatic-reviewer`, and `intention-reviewer`. Pass the inferred intent from step 2 to each so reviewers can validate findings against it.
   b. Tell every reviewer to inspect the actual current repository and diff, return only evidence-backed findings, and not modify project/source files. Returning findings through its response or configured output artifact is allowed.
   c. Wait for all reviewers. Synthesize their findings yourself, deduplicate them, reject optional scope expansion, and separate fixes worth doing now from deferred suggestions.
   d. If there are no meaningful fixes worth doing now, stop the loop.
   e. If a finding requires an unapproved product, API, architecture, or scope decision, stop and ask the user.
   f. Launch one `implementer` as the sole fix writer. Provide the accepted findings with file/line evidence, require focused validation, and prohibit unrelated changes.
   g. Wait for the fix writer, then begin the next review round.
7. Report the polished diff: changed files, fixes applied per round, deferred findings, unresolved risks, and whether the review/fix loop cap was reached.

Do not ask simplification, review, or fix children to launch further subagents. The parent decides which findings are meaningful and whether the loop continues.
