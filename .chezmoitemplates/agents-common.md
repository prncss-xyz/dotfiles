## Coding Style

Prefer coding assertions over defensive programming.

Except for JSDoc comments, never write comments unless explicitly asked to.

@ts-expect-error is acceptable for testing the typing of a function reject some combinations of arguments.

## Tool Output

Preprocess verbose tool output before returning it to the model. Keep raw logs and reports in /tmp. Return compact summaries, relevant failures, and changes from the baseline. Perform counting, filtering, source mapping, fingerprint comparison, and mutation-status comparison in code. Inspect raw output only to resolve a specific uncertainty. For long-running tools, emit brief progress summaries at most once per minute.
