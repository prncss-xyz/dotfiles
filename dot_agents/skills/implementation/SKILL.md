---
name: implementation
description: Implement a task, then review and fix it in a bounded loop, and write a reviewer-oriented implementation report
disable-model-invocation: true
---

Orchestrate the implementation of the task supplied with this invocation. Never edit project files yourself.

Inputs:

- **Task**: the `task.md` file supplied with the invocation. Without one, implement the whole plan.
- **Plan**: the plan the task file links to, else the supplied plan path, else `plan.md` beside the task file. Without a plan, implement from the task file alone. If an explicitly linked or supplied plan is missing, multiple plans are ambiguous, or neither a task nor a plan is available, stop and report it as a blocker.
- **Artifact dir**: the task file's directory, else the plan's.
- **Contract**: `api-contract.md` in the artifact dir, when present. Its entry points, types, errors, exports, and tests are approved; any change to them is an unapproved API decision.
- **Settled decisions**: `settled.md` in the artifact dir. Read it if present; otherwise create it before the first implementer run. You own it and update it after each round and user decision. Record only names and structures explicitly accepted or rejected, with their scope, reason, and decision source or round; a rejected finding alone does not settle its proposed alternative. Preserve earlier decisions and record any superseding decision with its reason. Pass the current file to every implementer and reviewer, including style-pass reviewers, as binding context. A reversal requires evidence of a concrete defect, not preference. It cannot override the task or contract.

Rules:

- Only one writer subagent runs at a time; wait for each to finish.
- Accumulate incomplete or deferred work from every implementer run and deferred or unresolved review findings from every round, with their location evidence and reasons, removing an item only when later evidence shows it resolved.
- If an unapproved product, API, architecture, or scope decision comes up, stop and ask the user.
- Validation gate: before review or the implementation report, the writer must show the commands run and passing results for every required test: the verification of each acceptance criterion and, with a contract, all its tests. Missing, skipped, failing, or deferred tests go back to the writer. If validation is blocked, ask the user; never waive it.
- Successful exit: `No new actionable findings`, `No new edits`, or `Post-style passed`, with all required validation passing, no remaining "fix now" findings or open user decisions, and no incomplete task requirements.

Workflow:

Before any check or possible exit, remove any `small-change.txt` from the artifact dir. If the dir cannot be resolved or the marker cannot be removed, stop and report the blocker.

1. Run `git status --porcelain --untracked-files=all`. If the working tree is not clean, ask the user how to proceed: the review scope is uncommitted work, so pre-existing changes would be reviewed as part of the task.
2. Launch a fresh `worker` told to read and follow [implementer.md](./implementer.md), with the plan path if any, the task file, the contract path if any, and required tests. Apply the validation gate.
3. Review/fix loop, at most 6 rounds:
   Before each round, compare the current tracked diff and untracked file contents with their state before the most recent implementer run. If that run made no edits, or no uncommitted changes remain, exit `No new edits` without invoking the review skill.
   a. Read and follow [the review skill](../review/SKILL.md) with no fixed point, so it reviews uncommitted work, and with the plan path and the task file as its intent: the task's acceptance criteria, scope edges, and constraints, not the hints in its notes, so an approach that meets the criteria differently is not a finding. Stylistic findings get the same classification and resolution criteria as any other; never downgrade or defer one for being stylistic. With a contract, pass it as settled: a finding that would change it is "needs user decision" or rejected as scope expansion, never "fix now".
   b. Bring "needs user decision" findings to the user. Update settled decisions before handing off or exiting. With no "fix now" findings, exit `No new actionable findings`. If all "fix now" findings are stylistic (they change form, never behavior) and no user decision is open, go to d. After round 6, exit `Review cycle limit reached`.
   c. Launch the implementer with the accepted findings and their `path:line` evidence, asking for no unrelated changes. Apply the validation gate. Start the next round.
   d. Style pass, allowed after round 6 and not counted as a round:
      1. Snapshot the tracked and untracked state.
      2. Launch the implementer for these style fixes only. Apply the validation gate; retries share the snapshot.
      3. Launch a `reviewer` following [precommit-reviewer.md](../review/precommit-reviewer.md).
      4. Launch a fresh `reviewer` following [post-style.md](./post-style.md) with the findings, the snapshot, the current state, and the validation and hook results.
      5. On `pass`, exit `Post-style passed`. Otherwise, retain its findings: with rounds remaining, return to c treating them as non-stylistic; after round 6, exit `Post-style failed`.
4. Read and follow [implementation-writer.md](./implementation-writer.md) directly, writing `implementation.md` in the artifact dir. Supply the plan path if any, the task, the contract path if any, the implementation and validation summary, the changed files, accumulated deferred and unresolved items, risks, the full review-round count, any post-style result, the loop exit reason, the final task diff's additions and deletions with the baseline and measurement commands/results (or that they are unmeasurable), and whether the run is a successful exit, with evidence.
5. On a successful exit with the report written, commit the task's changes using a Conventional Commits message.
6. Create a zero-byte `small-change.txt` in the artifact dir only once the commit has settled: the report's Small change is `yes`, the commit succeeded, and `git status --porcelain --untracked-files=all` then shows no left-over changes. Otherwise leave no marker.
7. On a successful exit after 4 or more review rounds, read and follow [the retro skill](../retro/SKILL.md) for the current implementation session. Use the full review-round count; the style pass does not count as a round.
8. Report the implementation report path, whether `small-change.txt` was created, the retro report path if triggered, and `Exit reason: <loop exit reason>`.
