## Coding Style

Prefer coding assertions over defensive programming.

Except for JSDoc comments, never write comments unless explicitly asked to.

@ts-expect-error is acceptable for testing the typing of a function reject some combinations of arguments.

Never write tests for codepaths that the type system already excludes, such as invalid inputs the signature rejects or states the types make unrepresentable. Do not bypass types with casts or `any` to reach them. Types that must reject some arguments are tested only with `@ts-expect-error`.

When adding new code or tests makes existing code or tests redundant, remove the redundant code or tests as part of the same change. This cleanup is your responsibility and does not require user permission.

## Commit Authorship

Never set yourself or any AI agent as the author or co-author of a commit. Use the user's configured Git identity and do not add AI attribution trailers.

## Tool Output

Preprocess verbose tool output before returning it to the model. Keep raw logs and reports in /tmp. Return compact summaries, relevant failures, and changes from the baseline. Perform counting, filtering, source mapping, fingerprint comparison, and mutation-status comparison in code. Inspect raw output only to resolve a specific uncertainty. For long-running tools, emit brief progress summaries at most once per minute.
