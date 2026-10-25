## Coding Style

Prefer coding assertions over defensive programming.

Never write comments unless explicitly asked to.

## Sandbox

You may write to the current project directory, `/tmp`, and `~/projects/notes/main/dev/artifacts`. Do not write elsewhere.

## File Manipulation

For any kind of complex file transform, use temporary JavaScript scripts. Prefer this over piping bash commands.

## Subagents

When launching a subagent,

- for implementation tasks, use { provider: "openai-codex", id: "gpt-6-luna", thinking: "medium" }
- for plannification and review tasks, use { provider: "openai-codex", id: "gpt-6.1-sol", thinking: "medium" }
