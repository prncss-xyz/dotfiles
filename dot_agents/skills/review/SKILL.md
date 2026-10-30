---
name: review
description: Review changes against a fixed point, or uncommitted work, with parallel fresh-context reviewers
disable-model-invocation: true
---

Orchestrate a review of one pinned change scope. Never modify project files yourself.

## Inputs

Both optional:

- **Fixed point**: a Git reference (commit SHA, branch, tag, `main`, `HEAD~5`), used exactly as written.
- **Intent**: a spec path, ticket URL, or task description stating what the change is meant to do. If none is supplied, look for a relevant `plan.md` in the artifacts directory; if several are plausible, ask the user.

## Pin the scope

Do this before launching any reviewer, and stop with a report on any error or empty scope; never defer these to reviewers.

- **With a fixed point**: resolve it with `git rev-parse`. The scope is `git diff <fixed-point>...HEAD` (three-dot, against the merge-base) and the commit list is `git log <fixed-point>..HEAD --oneline`.
- **Without one**: if `git status --porcelain --untracked-files=all` is non-empty, the scope is uncommitted work: `git diff HEAD` plus the untracked files from `git ls-files --others --exclude-standard`, treated as additions. Otherwise use `main` as the fixed point.

## Run reviewers

Each reviewer is a file next to this one. Launch one fresh `reviewer` subagent per file, telling it to read and follow that file:

1. [precommit-reviewer.md](./precommit-reviewer.md) — run it alone first, since the hook may modify files; then re-pin the scope.
2. In a single parallel run:
   - [design-reviewer.md](./design-reviewer.md)
   - [conventions-reviewer.md](./conventions-reviewer.md)
   - [intention-reviewer.md](./intention-reviewer.md), only when an intent is available

Give every reviewer the pinned scope commands, the untracked file list or commit list, and the intent if any. Tell each to inspect the actual repository, review only the pinned scope, return only evidence-backed findings citing `path:line`, and not modify project files.

Wait for every reviewer to finish. A reviewer that failed, or was skipped, is reported as such, never as having no findings.

## Synthesize

Deduplicate overlapping findings, reject scope expansion, and classify each as:

- fix now
- needs user decision
- optional or deferred
- rejected, with a brief reason

Present them under one heading per reviewer. When this skill is followed as part of another workflow, return the classified findings to it instead of acting on them.
