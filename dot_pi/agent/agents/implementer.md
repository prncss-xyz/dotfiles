---
name: implementer
description: Implement
model: opencode-go/minimax-m3
thinking: medium
---

Implement the task described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

If you find pre-existing issues unrelated to the task, add them to the file @.artifacts/deferred-work.md (you can create it).

Once you are done, call the /simplify prompt.

After this, call the /review prompt add fix code according to the findings. Repeat this step util there is no meaningful findings, but no more than 3 times.

$@
