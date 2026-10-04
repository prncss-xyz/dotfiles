---
name: my-review-code
description: Review code with an optional Git reference and spec file or ticket link. Default to uncommitted work, falling back to main when the working tree is clean.
disable-model-invocation: true
---

# Code Review

Coordinate reviewers for one shared review scope.

## Inputs

Accept two independent, optional inputs:

- **Fixed point:** a Git reference, such as a commit SHA, branch, tag, `main`, or `HEAD~5`.
- **Spec:** a local file path or a link to a Linear ticket, GitHub issue, or similar source of requirements.

Support `--fixed-point <ref>` and `--spec <path-or-url>` for explicit input labels. Also accept unambiguous bare references, paths, and URLs. If an input could identify either a Git reference or a spec, ask the user to disambiguate.

Examples:

- `--fixed-point main`
- `--spec ./plan.md`
- `--fixed-point HEAD~5 --spec https://github.com/owner/repo/issues/123`
- No inputs: select the default review scope and look for a local spec.

## Select and validate the review scope

Use an explicit fixed point exactly as written. If none is supplied, review uncommitted work, or if there is none, default to `main`. Supplying a spec does not change this default.

Before launching any subagents, select the scope:

- **Explicit fixed point:** use the reference comparison below.
- **No fixed point:** check `git status --porcelain --untracked-files=all`. If there are staged, unstaged, or untracked changes, use the uncommitted-work review below. Otherwise, use the reference comparison with `main`.

### Reference comparison

1. Resolve the fixed point with `git rev-parse <fixed-point>`. Stop and report the error if it does not resolve.
2. Capture the comparison command once as `git diff <fixed-point>...HEAD`. Use the three-dot form for this mode so the diff is against the merge-base.
3. Confirm that the comparison is non-empty. If it is empty, stop and report that there is nothing to review.
4. Capture the commit list with `git log <fixed-point>..HEAD --oneline`.

### Uncommitted work

1. Capture the comparison commands as `git diff --cached` for staged changes and `git diff` for unstaged changes. Review both so changes in one do not hide changes in the other.
2. Capture the untracked file list with `git ls-files --others --exclude-standard`. Include these files as new files in the review; ordinary Git diffs do not include them.
3. Confirm that at least one diff or the untracked file list is non-empty. Otherwise, stop and report that there is nothing to review.
4. Record the commit list as not applicable: this mode reviews uncommitted work, not a commit range.

Handle command errors and empty review scopes in the parent before launching reviewers. Do not defer them to child agents.

## Identify the spec reference in the parent task

Identify the spec reference before launching reviewers, without reading or retrieving its contents:

1. If the user supplied a spec, use its path or URL.
2. If no spec was supplied, look for a local artifact such as `.artifacts/<branch-name>/spec.md`, `plan.md`, or a similarly named spec or plan. Use filenames, locations, and task context to identify the relevant candidate. If multiple candidates are plausible and their relevance is unclear, ask the user which to use.
3. Record the selected reference. Resolve local paths to absolute paths so the subagent can locate the file; preserve URLs as supplied.

If no spec reference is supplied or found, skip the intention reviewer and continue the other reviews. The intention reviewer handles reading the file or retrieving the linked source and reports any access problem.

## Run reviewers

Resolve the linked paths relative to this document. Launch one subagent per file in a single parallel run, each with a fresh context. Give each subagent its resolved path and instruct it to read and follow the file:

- [Precommit Reviewer](./precommit-reviewer.md)
- [Idiomatic Reviewer](./idiomatic-reviewer.md)
- [Simplicity Reviewer](./simplicity-reviewer.md)

Include the [Intention Reviewer](./intention-reviewer.md) in that parallel run only when a spec reference is available. Pass it the selected path or URL and let it read or retrieve the spec. Spec discovery remains in the parent task.

Give every reviewer:

- The selected review mode and fixed point, if applicable.
- The exact captured comparison command or commands.
- The captured untracked file list for uncommitted work.
- The captured commit list, or its not-applicable status.
- The spec reference, when available, or a note that no spec reference was identified.

Instruct every reviewer to inspect the actual repository, review only the changes covered by the captured comparison commands and any captured untracked files, and return only findings supported by evidence. Treat untracked files as additions wherever reviewer instructions refer to the diff or its hunks. Reviewers must not modify project or source files. They may return findings in their response or a configured output artifact.

## Synthesize findings

Wait until every reviewer finishes. Present the results under one heading per reviewer, deduplicate overlapping findings, and classify each finding as:

- fix now
- needs user decision
- optional or deferred
- rejected, with a brief reason

If the intention reviewer was skipped or could not access the spec, state why. Do not present an unperformed review as having no findings.

## User inputs

$@
