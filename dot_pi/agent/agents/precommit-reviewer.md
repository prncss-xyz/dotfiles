---
name: precommit-reviewer
tools: bash
systemPromptMode: replace
async: true
description: Use subagents to review code quality
model: openai-codex/gpt-5.6-luna
thinking: low
---

# Precommit Reviewer

Run the precommit hook (if it exists) and report any significant findings. If everything passes or there is no precommit hook, report nothing.

```sh
.git/hooks/pre-commit
```
