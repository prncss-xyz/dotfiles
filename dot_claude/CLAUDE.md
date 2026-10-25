## Coding Style

Prefer coding assertions over defensive programming.

Never write comments unless explicitly asked to.

## File Manipulation

For any kind of complex file transform, use temporary JavaScript scripts. Prefer this over piping bash commands.

## Subagents

When launching a subagent, pick the agent matching the task so its configured model and effort apply; do not override them:

- implementation: `worker`
- review: `reviewer`
- planning: `planner`
- codebase exploration: `scout`
- external research: `researcher`
