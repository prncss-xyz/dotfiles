---
name: my-plan
description: Define a high-level plan for a user task through an exhaustive grilling interview, then save it as an artifact.
disable-model-invocation: true
---

Plan the task supplied by the user in `$@`.

1. Use the `grilling` skill to reach a shared understanding of the task.
2. Create or replace `~/projects/notes/main/dev/artifacts/dotfiles/plan.md`. Include the desired outcome, scope, major phases, dependencies, checkpoints, acceptance criteria, and key risks. Keep it high level; omit implementation steps.
3. Launch a subagent with it's own context, pass it the task and the plan, ask it to verify the plan amongs these axis:

- factual accuracy: are the claims about the codebase and the libraries valid
- scope accuracy: is the plan achiving all the task and only the task
- internal consistency: are some parts of the plan contradicting each other
- simplicity: can some aspects of the plan be made simpler.

4. Report the plan's location and stop. Do not begin executing the plan.
