---
name: decompose
description: Decompose a high level plan into actionable steps
disable-model-invocation: true
---

Decompose the task supplied with this invocation into a plan written to the artifact file `todo.md`. Before planning, check whether the file already exists; if it does, report it and stop. The deliverable is the plan; implementation happens in a separate invocation.

## Define vertical slices

Each slice delivers a small, independently verifiable outcome, spanning whatever layers are needed to achieve it.

Give each slice a Markdown heading and a brief statement of its outcome.

## Define atomic steps

Break each slice into atomic steps, formatted as `- [ ] {step}`. Each step includes one concrete action, an observable completion condition, and how to verify that condition as part of the step.

For both slices and steps, place dependencies first. Among items whose dependencies are satisfied, put the simplest first.

## Check and save

Before writing `todo.md`, check that every requested outcome is covered, dependencies appear before their dependents, and every step includes verification of its completion condition.

Write the plan and report its path.
