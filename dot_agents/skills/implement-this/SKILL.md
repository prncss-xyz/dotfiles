---
name: implement-this
description: Implement a task or prompt file from a clean working tree, review for up to five rounds, report the outcome, and commit successful work.
disable-model-invocation: true
---

# Implement This

Coordinate implementation and reviewers for one task.

## Inputs

Accept a task prompt or a path to a local prompt file. Pass the prompt to the implementation subagent. If given a file, resolve it to an absolute path so the subagent can read it. Keep the prompt or file path as the spec for the intention reviewer.

## Implement

Before implementation, run `git status --porcelain=v1 --untracked-files=all`. If it fails, stop and report the error. If there are any staged, unstaged, or untracked changes, refuse to proceed and report them. Do not stash, discard, or commit existing changes.

Launch one implementation subagent with a fresh context. Give it the task prompt or resolved file path and instruct it to implement the task in the repository, leaving changes uncommitted. Ask it to return validation results, unrelated issues encountered, and deviations from the supplied plan or task requirements. Wait for it to finish before reviewing.

## Precommit check

At the start of each review round, run the [Precommit Reviewer](./precommit-reviewer.md) and wait for it to finish before capturing the review scope or launching the other reviewers. The hook may modify files. Include those changes in the subsequent review. Skip the hook if it does not exist.

## Select and validate the review scope

Review the currently changed files after implementation and after each fix round. Before launching reviewers, capture `git status --porcelain=v1 --untracked-files=all`. This lists staged, unstaged, and untracked files. Exclude workflow artifacts from the review scope. If the scope is empty, proceed directly to the report, stating that there is nothing to review or commit.

Handle command errors and empty review scopes in the parent before launching reviewers. Do not defer them to child agents.

## Run reviewers

Resolve the linked paths relative to this document. Launch one subagent per file in a single parallel run, each with a fresh context. Give each subagent its resolved path and instruct it to read and follow the file:

- [Idiomatic Reviewer](./idiomatic-reviewer.md)
- [Simplicity Reviewer](./simplicity-reviewer.md)
- [Intention Reviewer](./intention-reviewer.md)

Pass the intention reviewer the task prompt or resolved file path. Give every reviewer:

- The captured Git status output.
- The task prompt or file path.

Instruct every reviewer to inspect the actual repository, review only the changes in the files listed by the captured Git status output, and return only findings supported by evidence. Treat untracked files as additions wherever reviewer instructions refer to the diff or its hunks. These reviewers must not modify files. They must return findings, including any unrelated issues encountered, to the parent for the final report.

## Review and fix loop

Wait until every reviewer finishes. Deduplicate overlapping findings and classify each as:

- fix now
- needs user decision
- optional or deferred
- rejected, with a brief reason

Count the initial review as round one. After rounds one through four, apply the fix-now findings and run appropriate validation, then start the next review round with the precommit check. Stop early when there are no actionable unresolved concerns and validation passes. If a finding needs a user decision before implementation can continue, ask the user with the harness-provided tool.

Round five is the final review: do not apply fixes after it. The last code changes, including hook changes, must always receive a completed review before the workflow ends. Treat failed or incomplete reviews as unresolved concerns; do not present an unperformed review as having no findings.

## Report and commit

For both successful and unsuccessful outcomes, append a dated task entry to `report.md` in the configured artifact directory, creating the directory and file if needed. Preserve existing report contents.

Include the outcome, review rounds completed, validation results, remaining concerns with their dispositions, unrelated issues encountered, and deviations from the supplied plan or task requirements with reasons. Explicitly state when there are no unrelated issues or deviations. If no plan was supplied, say so and report any deviations from the task requirements. Report unrelated issues encountered during the work without expanding the task to fix them.

If actionable concerns remain after the final round, validation fails, or any required review is incomplete, write the report and leave the implementation uncommitted. Optional or deferred concerns must also appear in the report; do not silently treat them as resolved.

When all actionable concerns are resolved, required reviews are complete, and validation passes, commit the reviewed implementation using a Conventional Commit message such as `fix(scope): correct the described behavior`. Do not bypass hooks. Record the commit hash in the report on success, or the error if committing fails. Do not create an empty commit when there is nothing to commit.

In the final response, link the report and state whether the work was committed or has unresolved concerns.

## User inputs

$@
