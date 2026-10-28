---
name: scaffold-api
description: Scaffold a caller-facing API with typed stubs, failing behavior tests, review, and a contract handoff before implementation.
---

Scaffold the supplied task without implementing behavior. Delegate project edits to one `worker` at a time; own the boundary, review, and handoff.

## Boundary

Define the smallest interface consumers need across a named module/package/service boundary: entry points, types, errors, and exports. Public visibility alone does not justify inclusion. Exclude internals and speculative extensions; never widen the API for testability. Preserve existing contracts unless the task requires changes.

Infer routine choices from the spec and repository; ask only about decisions that materially change caller guarantees.

## Workflow

1. Read repository instructions, spec, test conventions, and `git status --porcelain --untracked-files=all`. Preserve pre-existing changes; ask about inseparable overlap. Use the repository's artifact directory, else the spec's directory, else ask.
2. Launch a fresh `worker` with [scaffolder.md](./scaffolder.md), task, boundary, required behaviors/checks, existing changes, and artifact directory.
3. Enforce the validation gate below; return deficiencies to the worker.
4. Run [review-api](../review-api/SKILL.md) with the task-owned diff, added files, boundary, intent, and evidence. Have the worker fix `fix now` findings, revalidate, and repeat review; escalate `needs user decision`. Stop incomplete after 6 rounds with required findings unresolved.
5. Write `api-contract.md` per [contract-writer.md](./contract-writer.md).
6. Only after scaffolding, validation, review, and the report succeed with no unresolved required findings or decisions, commit the task's changes using `git commit --no-verify` with a Conventional Commits message. Expected-red behavior tests satisfying the validation gate count as success. Do not commit failed, blocked, or incomplete work, or include pre-existing changes. If the commit fails, report the failure without claiming success.
7. On success, report only the report path.

## Validation gate

Require exact commands, exit statuses, and per-test outcomes:

- Each new behavior test reaches its intended boundary and fails for missing behavior. An unimplemented exception counts even when expecting a domain error; discovery/import/setup/environment failures do not.
- Compilation/type checks pass. No new tests are skipped, pending, disabled, or marked expected-failure; no placeholder assertions, unconditional failures, or weakened assertions.
- Label each regression test with its preservation requirement; prove it passes before and after scaffolding. Pure refactors may have only regressions. Never stub working code to force red; investigate unexpected passes.
- Compare existing tests against a pre-edit baseline; record pre-existing failures separately. New failures elsewhere block completion.
- Rerun affected checks after fixes. Unavailable required checks block completion.
