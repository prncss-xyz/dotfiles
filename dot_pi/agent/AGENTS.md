## Coding Style

Prefer coding assertions over defensive programming.

Except for JSDoc comments, never write comments unless explicitly asked to.

@ts-expect-error is acceptable for testing the typing of a function reject some combinations of arguments.

## File Manipulation

For any kind of complex file transform, prefer using code mode over piping bash commands.

## Subagents

When launching a subagent, pick the builtin agent matching the task so its configured model and thinking level apply; do not override them:

- implementation: `worker`
- review: `reviewer`
- planning: `planner`
- codebase exploration: `scout`
- external research: `researcher`
