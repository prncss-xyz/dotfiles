---
name: decompose
description: Decompose a high level plan into one task file per slice
disable-model-invocation: true
---

Decompose the task supplied with this invocation into slices, writing one artifact file per slice named `{dd}-{name}.task.md`: `dd` is the slice's two-digit position in the order (`01`, `02`, …) and `name` is a single lowercase word identifying the slice. The task is usually a path to a design plan (such as the `plan.md` produced by the plannifier); read it first, and write the task files beside it. Before planning, check whether any `*.task.md` file already exists there; if one does, report it and stop. The deliverable is the task files; implementation happens in separate invocations, one per task file.

## Respect the design

Treat the decisions in a supplied plan as settled, including its delivery constraints: don't reopen, reinterpret, or extend them. If a slice would require a design decision the plan leaves open, don't make it: list it under a final `## Open questions` heading in the affected task file instead.

## Define vertical slices

Each slice delivers a small, independently verifiable outcome, spanning whatever layers are needed to achieve it. Use only the temporary scaffolding the plan allows.

Use tracer bullets, not layers: start with the smallest end-to-end path (the plan's first outcome, if it names one), then extend it with additional behavior. Don't split the work into horizontal phases such as all storage, then all backend, then all UI; that postpones verification until several phases land. For example, prefer "create and retrieve one saved item" followed by "list and filter saved items" over separate database, API, and UI slices.

No completion condition may depend on a later slice. If a slice can't be verified without unfinished work elsewhere, merge the coupled work or redraw the boundary.

If the plan calls for prefactoring, give it its own slice before the slices it enables, verified by behavior-preservation checks. Don't invent a broad cleanup or infrastructure slice.

Each slice is scaffolded, implemented, reviewed, and committed on its own; size it accordingly. Start each task file with a heading stating the slice's outcome, a link to the plan, and a brief statement of the outcome, marking optional follow-ups as optional and slices that introduce or alter a caller-facing boundary as `(scaffold)`. A small task may be a single slice; don't split an outcome only to produce more slices.

## Define acceptance criteria

Give each slice acceptance criteria, formatted as `- {observable outcome} — {how it is verified}`. Each criterion states what the slice must demonstrably achieve, not how to achieve it; the implementer chooses the approach. Verify behavior end to end through real entry points rather than intermediate states. Where the plan defines how evidence is gathered, use it for verification.

State the slice's scope edges: what it deliberately leaves to later slices, so it isn't built ahead. Carry over the plan's constraints that apply to the slice: invariants and the temporary scaffolding it may use.

Optionally add a `## Notes` section with implementation hints, labeled as non-binding. Size slices by the work they imply, but keep implementation actions out of the criteria.

## Order

Place slices with dependencies first, then any ordering the plan requires; otherwise, simplest first. Optional slices come after all gates. Record only real blocking dependencies in the dependent task file, naming the prerequisite task file and what it supplies.

## Check and save

Before writing the task files, check that every requested outcome and gate is covered by some criterion, the order holds, every criterion is observable and states its verification, and each slice is small enough to implement and review on its own.

Write the task files and report their paths, along with any open questions.
