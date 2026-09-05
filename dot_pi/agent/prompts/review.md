---
description: Run parallel fresh-context reviewers
---

Act as the parent review orchestrator for the current diff.

Launch these agents in one parallel `subagent` run with `async: true` and `context: "fresh"`:

- `precommit-reviewer`
- `quality-reviewer`
- `idiomatic-reviewer`
- `intention-reviewer`

Tell each reviewer to inspect the actual repository and current diff, return only evidence-backed findings, and not modify project/source files. Returning findings through its response or configured output artifact is allowed.

Use `wait()` until every reviewer finishes. Then synthesize the results under one heading per reviewer. Deduplicate overlapping findings and classify each as:

- fix now
- needs user decision
- optional or deferred
- rejected, with a brief reason

$@
