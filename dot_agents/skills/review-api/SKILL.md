---
name: review-api
description: Review an API scaffold for contract quality, scope, and valid failing-test evidence before implementation.
---

Review without editing files or expecting stubs to work.

## Scope

Use the caller's task-owned diff, added files, intent, boundary, and validation evidence. When invoked directly, inspect `git diff HEAD` and files from `git ls-files --others --exclude-standard`; ask about unclear ownership or intent. Review only task-owned changes, using surrounding code as context. Stop on empty or unreadable scope.

## Review

Launch one fresh `reviewer` with the scope and evidence to inspect actual files for:

- **Contract**: minimal, complete, idiomatic entry points, types, errors, exports, and compatibility. New concrete bodies only throw/panic; signatures describe intended results, not placeholder-inferred `never`. Required existing behavior remains intact.
- **Tests**: specified observable outcomes through real entry points; no mocked subject or private-detail coupling. Construction/setup must not mask individual cases.
- **Evidence**: meets the [validation gate](../scaffold-api/SKILL.md#validation-gate).

Require evidence-backed findings with `path:line` and the violated requirement/convention; identify missing validation by test/check. Do not request implementation or run mutating hooks. A failed review run is incomplete.

## Report

Deduplicate and classify findings as `fix now`, `needs user decision`, `deferred`, or `rejected`, with reasons; reject scope expansion. Include validation uncertainty. Return to the caller or, when invoked directly, the user.
