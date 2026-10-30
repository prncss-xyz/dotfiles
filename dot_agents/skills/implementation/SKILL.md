---
name: implementation
description: Implement a task or one slice of a plan, then review and fix it in a bounded loop, and write a reviewer-oriented implementation report
disable-model-invocation: true
---

Orchestrate the implementation of the slice supplied with this invocation. Never edit project files yourself.

Inputs, read from the artifact directory:

- **Slice**: the `task.md` or `{dd}-{name}.task.md` file supplied with the invocation. Without one, the slice is the whole plan.
- **Plan**: the plan the task file links to, else the supplied plan path, else `plan.md` beside the task file. If no plan exists and a task file is supplied, implement directly from that task's acceptance criteria, scope edges, and constraints without creating a plan. If an explicitly linked or supplied plan is missing, multiple plans are ambiguous, or neither a task nor a plan is available, stop and report it as a blocker. Pass the plan path to subsequent steps only when a plan exists.
- **Contract**: `{dd}-{name}.api-contract.md` beside the task file, or `api-contract.md` when the slice is the whole plan, when present. Its entry points, types, errors, exports, and tests are approved decisions: they must not be changed, and its tests must not be modified, weakened, skipped, or deleted. A needed change to them is an unapproved API decision.

Rules:

- Only one writer subagent runs at a time; wait for each to finish.
- Retain incomplete or deferred work reported by every implementer run and deferred or unresolved review findings across all rounds, including their location evidence and reasons for deferral. Pass the accumulated items to the implementation report writer, removing an item only when later implementation or validation evidence shows it was resolved.
- If an unapproved product, API, architecture, or scope decision comes up, stop and ask the user.
- Validation gate: before review or implementation report, the writer must show the commands run and passing results for every required test: the verification of each of the slice's acceptance criteria and, when a contract exists, all of its tests. Missing, skipped, failing, or deferred tests go back to the writer. If validation is blocked, ask the user; never waive it.

Workflow:

1. Run `git status --porcelain --untracked-files=all`. If the working tree is not clean, ask the user how to proceed: the review scope is uncommitted work, so pre-existing changes would be reviewed as part of the slice.
2. Launch a fresh `worker` told to read and follow [implementer.md](./implementer.md), with the plan path, the task file, the contract path if any, and required tests. Apply the validation gate.
3. Review/fix loop, at most 6 rounds:
   Before each round, compare the current tracked diff and untracked file contents with their state before the most recent implementer run. If that run made no edits, or no uncommitted changes remain, exit with reason `No new edits` without invoking the review skill. Existing changes from an earlier round do not count as new edits.
   a. Read and follow [the review skill](../review/SKILL.md) with no fixed point, so it reviews uncommitted work, and with the plan path and the task file as its intent: the slice's acceptance criteria, scope edges, and constraints, not the hints in its notes, so an approach that meets the criteria differently is not a finding. Instruct reviewers and the review orchestrator to give stylistic findings the same weight as other findings: apply the same classification and resolution criteria, and never downgrade or defer a finding solely because it concerns style. When a contract exists, pass it as settled: a finding that would change it is classified "needs user decision" or rejected as scope expansion, never "fix now".
   b. Bring "needs user decision" findings to the user. If no "fix now" findings remain, exit with reason `No new actionable findings`. If this round and the immediately preceding review round both yielded only stylistic findings, and no unresolved non-stylistic findings or user decisions remain, do not address this round's findings: retain them as deferred, exit with reason `Consecutive style-only reviews`, and consider the implementation successful once validation passes and the implementation report is written. A round with no findings does not count as a style-only round. Otherwise, if 6 review rounds have completed, exit with reason `Review cycle limit reached`, retaining the unresolved findings; do not launch another implementer run.
   c. Launch the implementer again with the accepted findings and their `path:line` evidence, asking for focused validation and no unrelated changes. Apply the validation gate.
4. Read and follow [implementation-writer.md](./implementation-writer.md) directly, using the plan path if any, the slice, the contract path if any, the implementation and validation summary, the changed files, deferred and unresolved findings, risks, the number of review rounds, and the loop exit reason (`No new actionable findings`, `No new edits`, `Consecutive style-only reviews`, or `Review cycle limit reached`). Include that reason in the implementation report. The output is `{dd}-{name}.implementation.md` beside a numbered task file, or `implementation.md` beside `task.md` or the plan when the slice is the whole plan.
5. On success, after validation passes, no "fix now" findings remain (except stylistic findings deferred under `Consecutive style-only reviews`), and the implementation report is written, commit the slice's changes using a Conventional Commits message.
6. Report the implementation report path and `Exit reason: <loop exit reason>`.
