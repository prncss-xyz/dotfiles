---
name: decompose
description: Decompose a high level plan into actionable steps
disable-model-invocation: true
---

Decompose the task supplied with this invocation into a plan written to the artifact file `todo.md`. The task is usually a path to a design plan (such as the `plan.md` produced by the plannifier); read it first. Before planning, check whether `todo.md` already exists; if it does, report it and stop. The deliverable is the plan; implementation happens in a separate invocation.

## Respect the design

Treat the decisions in a supplied plan as settled, including its delivery constraints: don't reopen, reinterpret, or extend them. If a step would require a design decision the plan leaves open, don't make it: list it under a final `## Open questions` heading instead.

## Define vertical slices

Each slice delivers a small, independently verifiable outcome, spanning whatever layers are needed to achieve it. Use only the temporary scaffolding the plan allows.

Use tracer bullets, not layers: start with the smallest end-to-end path (the plan's first outcome, if it names one), then extend it with additional behavior. Don't split the work into horizontal phases such as all storage, then all backend, then all UI; that postpones verification until several phases land. For example, prefer "create and retrieve one saved item" followed by "list and filter saved items" over separate database, API, and UI slices.

No completion condition may depend on a later slice. If a slice can't be verified without unfinished work elsewhere, merge the coupled work or redraw the boundary.

If the plan calls for prefactoring, give it its own slice before the slices it enables, verified by behavior-preservation checks. Don't invent a broad cleanup or infrastructure slice.

Give each slice a Markdown heading and a brief statement of its outcome, marking optional follow-ups as optional. A small task may be a single slice; don't split an outcome only to produce more slices.

## Define atomic steps

Break each slice into atomic steps, formatted as `- [ ] {step}`. Each step includes one concrete action, an observable completion condition, and how to verify that condition as part of the step. Where the plan defines how evidence is gathered, use it for verification. A slice may consist of a single step when its outcome is achieved by one action.

## Order

For both slices and steps, place dependencies first, then any ordering the plan requires; otherwise, simplest first. Optional slices come after all gates. Record only real blocking dependencies, stating what each prerequisite supplies.

## Check and save

Before writing `todo.md`, check that every requested outcome and gate is covered, the order holds, and every step verifies its completion condition.

Write the plan and report its path, along with any open questions.
