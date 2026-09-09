---
description: Run parallel fresh-context reviewers
---

Act as the parent review orchestrator for changes relative to one pinned fixed point.

## Pin and validate the fixed point

Treat the user's argument as the fixed point exactly as written (for example, a commit SHA, branch, tag, `main`, or `HEAD~5`). If no argument was supplied, use `main`.

Before launching any subagents:

1. Resolve the fixed point with `git rev-parse <fixed-point>`. Stop and report the error if it does not resolve.
2. Capture the comparison command once as `git diff <fixed-point>...HEAD`. Always use the three-dot form so the diff is against the merge-base.
3. Confirm that comparison is non-empty. Stop and report that there is nothing to review if it is empty.
4. Capture the commit list with `git log <fixed-point>..HEAD --oneline`.

Do not defer bad-ref or empty-diff handling to child agents.

## Run reviewers

Launch these agents in one parallel `subagent` run with `async: true` and `context: "fresh"`:

- `precommit-reviewer`
- `quality-reviewer`
- `idiomatic-reviewer`
- `intention-reviewer`
- `simplicity-reviewer`

Pass every reviewer the pinned fixed point, the exact captured `git diff <fixed-point>...HEAD` command, and the captured commit list. Tell each reviewer to inspect the actual repository and only the changes produced by that exact diff command, return only evidence-backed findings, and not modify project/source files. Returning findings through its response or configured output artifact is allowed.

Use `wait()` until every reviewer finishes. Then synthesize the results under one heading per reviewer. Deduplicate overlapping findings and classify each as:

- fix now
- needs user decision
- optional or deferred
- rejected, with a brief reason

$@
