---
description: Implement, simplify, review, and fix a task
---

Act as the parent orchestrator for this implementation. The user's task is:

$@

Keep all project-file writes single-threaded. Use `async: true` for every subagent launch and use `wait()` when a result is required. Do not finish while a promised implementation, simplification, review, or fix run is still active.

Workflow:

1. Launch `implementer` as the sole writer. Give it the task above, relevant specification paths or approved decisions already present in the conversation, success criteria, validation expectations, and the instruction to escalate unapproved decisions.
2. Wait for implementation to finish. If it reports an unresolved product, API, architecture, or scope decision, stop and ask the user.
3. Launch `simplifier` as the sole writer. Ask it to simplify only the implementation diff.
4. Wait for simplification to finish.
5. Run the review/fix loop below for at most four rounds:
   a. Launch these agents in parallel with `context: "fresh"`: `precommit-reviewer`, `quality-reviewer`, `idiomatic-reviewer`, and `intention-reviewer`.
   b. Tell every reviewer to inspect the actual current repository and diff, return only evidence-backed findings, and not modify project/source files. Returning findings through its response or configured output artifact is allowed.
   c. Wait for all reviewers. Synthesize their findings yourself, deduplicate them, reject optional scope expansion, and separate fixes worth doing now from deferred suggestions.
   d. If there are no meaningful fixes worth doing now, stop the loop.
   e. If a finding requires an unapproved product, API, architecture, or scope decision, stop and ask the user.
   f. Launch one `implementer` as the sole fix writer. Provide the accepted findings with file/line evidence, require focused validation, and prohibit unrelated changes.
   g. Wait for the fix writer, then begin the next review round.
6. Report changed files, tests/checks and results, deferred findings, unresolved risks, and whether the review/fix loop cap was reached.

Do not ask implementation or review children to launch further subagents. The parent decides which findings are meaningful and whether the loop continues.
