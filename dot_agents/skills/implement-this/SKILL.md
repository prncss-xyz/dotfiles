---
name: implement-this
description: Implement a task or prompt file, then review and fix the changed files for up to five review rounds.
disable-model-invocation: true
---

# Implement This

Coordinate implementation and reviewers for one task.

## Inputs

Accept a task prompt or a path to a local prompt file. Pass the prompt to the implementation subagent. If given a file, resolve it to an absolute path so the subagent can read it. Keep the prompt or file path as the spec for the intention reviewer.

## Implement

Launch one implementation subagent with a fresh context. Give it the task prompt or resolved file path and instruct it to implement the task in the repository. Wait for it to finish before reviewing.

## Select and validate the review scope

Review the currently changed files after implementation and after each fix round. Before launching reviewers, capture `git status --porcelain=v1 --untracked-files=all`. This lists staged, unstaged, and untracked files. If the output is empty, stop and report that there is nothing to review.

Handle command errors and empty review scopes in the parent before launching reviewers. Do not defer them to child agents.

## Run reviewers

Resolve the linked paths relative to this document. Launch one subagent per file in a single parallel run, each with a fresh context. Give each subagent its resolved path and instruct it to read and follow the file:

- [Precommit Reviewer](./precommit-reviewer.md)
- [Idiomatic Reviewer](./idiomatic-reviewer.md)
- [Simplicity Reviewer](./simplicity-reviewer.md)
- [Intention Reviewer](./intention-reviewer.md)

Pass the intention reviewer the task prompt or resolved file path. Give every reviewer:

- The captured Git status output.
- The task prompt or file path.

Instruct every reviewer to inspect the actual repository, review only the changes in the files listed by the captured Git status output, and return only findings supported by evidence. Treat untracked files as additions wherever reviewer instructions refer to the diff or its hunks. Reviewers must not modify project or source files. They may return findings in their response or a configured output artifact.

## Review and fix loop

Wait until every reviewer finishes. Deduplicate overlapping findings and classify each as:

- fix now
- needs user decision
- optional or deferred
- rejected, with a brief reason

Apply the fix-now findings, then capture the current review scope and run the same reviewers again. Repeat until there are no fix-now findings or five review rounds have completed. If a finding needs a user decision before implementation can continue, ask the user. Report remaining findings when the loop ends. Do not present an unperformed review as having no findings.

## User inputs

$@
