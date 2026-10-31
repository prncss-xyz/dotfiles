---
name: implementation
description: Implement a task, then review and fix it in a bounded loop, and write a reviewer-oriented implementation report
disable-model-invocation: true
---

Orchestrate the implementation of the task supplied with this invocation. Never edit project files yourself.

Inputs, read from the artifact directory:

- **Task**: the `task.md` file supplied with the invocation. Without one, implement the whole plan.
- **Plan**: the plan the task file links to, else the supplied plan path, else `plan.md` beside the task file. If no plan exists and a task file is supplied, implement directly from that task's acceptance criteria, scope edges, and constraints without creating a plan. If an explicitly linked or supplied plan is missing, multiple plans are ambiguous, or neither a task nor a plan is available, stop and report it as a blocker. Pass the plan path to subsequent steps only when a plan exists.
- **Contract**: `api-contract.md` beside the task file or, without one, the plan, when present. Its entry points, types, errors, exports, and tests are approved decisions: they must not be changed, and its tests must not be modified, weakened, skipped, or deleted. A needed change to them is an unapproved API decision.

Rules:

- Only one writer subagent runs at a time; wait for each to finish.
- Retain incomplete or deferred work reported by every implementer run and deferred or unresolved review findings across all rounds, including their location evidence and reasons for deferral. Pass the accumulated items to the implementation report writer, removing an item only when later implementation or validation evidence shows it was resolved.
- If an unapproved product, API, architecture, or scope decision comes up, stop and ask the user.
- Validation gate: before review or implementation report, the writer must show the commands run and passing results for every required test: the verification of each of the task's acceptance criteria and, when a contract exists, all of its tests. Missing, skipped, failing, or deferred tests go back to the writer. If validation is blocked, ask the user; never waive it.

Workflow:

1. Run `git status --porcelain --untracked-files=all`. If the working tree is not clean, ask the user how to proceed: the review scope is uncommitted work, so pre-existing changes would be reviewed as part of the task.
2. Launch a fresh `worker` told to read and follow [implementer.md](./implementer.md), with the plan path, the task file, the contract path if any, and required tests. Apply the validation gate.
3. Review/fix loop, at most 6 rounds:
   Before each round, compare the current tracked diff and untracked file contents with their state before the most recent implementer run. If that run made no edits, or no uncommitted changes remain, exit with reason `No new edits` without invoking the review skill. Existing changes from an earlier round do not count as new edits.
   a. Read and follow [the review skill](../review/SKILL.md) with no fixed point, so it reviews uncommitted work, and with the plan path and the task file as its intent: the task's acceptance criteria, scope edges, and constraints, not the hints in its notes, so an approach that meets the criteria differently is not a finding. Instruct reviewers and the review orchestrator to give stylistic findings the same weight as other findings: apply the same classification and resolution criteria, and never downgrade or defer a finding solely because it concerns style. When a contract exists, pass it as settled: a finding that would change it is classified "needs user decision" or rejected as scope expansion, never "fix now".
   b. Bring "needs user decision" findings to the user. With no "fix now" findings, exit `No new actionable findings`. If all "fix now" findings are stylistic (they change form, never behavior) and no user decision is open, go to d. After round 6, exit `Review cycle limit reached`, retaining unresolved findings.
   c. Launch the implementer with the accepted findings and their `path:line` evidence, asking for no unrelated changes. Apply the validation gate. Start the next round.
   d. Style pass, allowed after round 6 and not counted as a round:
      1. Snapshot the tracked and untracked state.
      2. Launch the implementer for these style fixes only. Apply the validation gate; retries share the snapshot.
      3. Launch a `reviewer` following [precommit-reviewer.md](../review/precommit-reviewer.md).
      4. Launch a fresh `reviewer` following [post-style.md](./post-style.md) with the findings, the snapshot, the current state, and the validation and hook results.
      5. On `pass`, exit `Post-style passed`. Otherwise, retain its findings: with rounds remaining, return to c treating them as non-stylistic; after round 6, exit `Post-style failed`.
4. Read and follow [implementation-writer.md](./implementation-writer.md) directly, using the plan path if any, the task, the contract path if any, the implementation and validation summary, the changed files, deferred and unresolved findings, risks, the number of full review rounds, any post-style result, and the loop exit reason (`No new actionable findings`, `No new edits`, `Post-style passed`, `Post-style failed`, or `Review cycle limit reached`). Include that reason and any post-style result in the implementation report. The output is `implementation.md` beside the task file or, without one, the plan.
5. On a `No new actionable findings`, `No new edits`, or `Post-style passed` exit, with validation passing, no "fix now" findings or open user decisions, and the report written, commit the task's changes using a Conventional Commits message.
6. Report the implementation report path and `Exit reason: <loop exit reason>`.
