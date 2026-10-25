---
name: implement
description: Implement a task, then review and fix it in a bounded loop, and write a reviewer walkthrough
disable-model-invocation: true
---

Orchestrate the implementation of the task supplied with this invocation. Never edit project files yourself.

Rules:

- Only one writer subagent runs at a time; wait for each to finish.
- If an unapproved product, API, architecture, or scope decision comes up, stop and ask the user.
- Validation gate: before review or walkthrough, the writer must show the commands run and passing results for every required test. Missing, skipped, failing, or deferred tests go back to the writer. If validation is blocked, ask the user; never waive it.

Workflow:

1. Run `git status --porcelain --untracked-files=all`. If the working tree is not clean, ask the user how to proceed: the review scope is uncommitted work, so pre-existing changes would be reviewed as part of the task.
2. Launch a fresh-context subagent told to read and follow [implementer.md](./implementer.md), with the task, relevant spec paths or approved decisions, success criteria, and required tests. Apply the validation gate.
3. Review/fix loop, at most 6 rounds:
   a. Read and follow [the review skill](../review/SKILL.md) with no fixed point, so it reviews uncommitted work, and with the task or spec path as its intent.
   b. Bring "needs user decision" findings to the user. If no "fix now" findings remain, exit the loop.
   c. Launch the implementer again with the accepted findings and their `path:line` evidence, asking for focused validation and no unrelated changes. Apply the validation gate.
4. Launch a fresh-context subagent told to read and follow [walkthrough-writer.md](./walkthrough-writer.md), with the originating spec path, the implementation and validation summary, the changed files, deferred findings, risks, and whether the loop cap was hit. If it cannot identify a single originating spec, report that as a blocker.
5. Report the walkthrough path, changed files, test results, deferred findings, risks, the number of review rounds, and whether the loop cap was hit.
