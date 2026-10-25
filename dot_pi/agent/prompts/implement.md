---
description: Implement, review, and fix a task
---

Orchestrate the implementation of:

$@

Rules:
- Only one writer subagent runs at a time. Launch subagents with `async: true` and `wait()` for each one.
- If an unapproved product, API, architecture, or scope decision comes up, stop and ask the user.
- Validation gate: before review or walkthrough, the writer must show the commands run and passing results for every required test. Missing, skipped, failing, or deferred tests go back to the writer. If validation is blocked, ask the user; never waive it.

Workflow:

1. Launch `implementer` with the task, relevant spec paths or approved decisions, success criteria, and required tests. Apply the validation gate.
2. Review/fix loop, at most 6 rounds:
   a. Run `precommit-reviewer`, `quality-reviewer`, `idiomatic-reviewer`, `intention-reviewer`, and `simplicity-reviewer` in parallel with `context: "fresh"`.
   b. Deduplicate their findings, reject scope expansion, and split them into fix-now and deferred. If nothing needs fixing now, exit the loop.
   c. Launch `implementer` with the accepted findings (with file/line evidence), and ask for focused validation and no unrelated changes. Apply the validation gate.
3. Launch `walkthrough-writer` with the originating spec path, the implementation and validation summary, the changed files, deferred findings, risks, and whether the loop cap was hit. It writes `review.md`; if it can't identify a single originating spec, report that as a blocker.
4. Report the `review.md` path, changed files, test results, deferred findings, risks, how many workflow cycles went through, and whether the loop cap was hit.
