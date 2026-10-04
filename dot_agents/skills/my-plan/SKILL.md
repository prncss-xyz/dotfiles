---
name: my-plan
description: Define a high-level plan for a user task through an exhaustive grilling interview, then save it as an artifact.
disable-model-invocation: true
---

Plan the task supplied by the user in `$@`.

## 1

Use the `grilling` skill to reach a shared understanding of the task.

## 2

Create or replace `~/projects/notes/main/dev/artifacts/dotfiles/plan.md`. Include the desired outcome, scope, major phases, dependencies, checkpoints, acceptance criteria, and key risks. Keep it high level; omit implementation steps.

## 3

Launch a subagent with it's own context, pass it the task and the plan, ask it to verify the plan amongs these axis:

- Factual accuracy: are the claims about the codebase and the libraries valid?
- Scope accuracy: is the plan achiving all the task and only the task?
- Internal consistency: are some parts of the plan contradicting each other?
- Simplicity: can some aspects of the plan be made simpler?

Require actionable findings with the affected plan section, supporting evidence, and a suggested correction. Unverifiable claims should be identified as such.

## 4

Wait for the review. Verify findings and revise the plan to address valid issues. If a finding requires a new user decision, return to the interview for that decision before finalizing. Request a focused recheck only when revisions materially change the approach or leave a substantive finding unresolved.

## 5

Report the plan's location and stop. Do not begin executing the plan.
