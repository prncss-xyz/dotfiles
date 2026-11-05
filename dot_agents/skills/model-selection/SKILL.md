---
name: model-selection
description: Choose a model weight and reasoning effort before dispatching a task or subagent.
user-invocable: false
---

Honor explicit user selections. Otherwise default to medium weight and choose by verifiability, dependent reasoning steps, ambiguity, and cost of error. Prompt length alone does not measure difficulty.

| Weight | Model families | Use for |
| --- | --- | --- |
| Low | Luna, Haiku | Mechanical transformations, targeted extraction, lookups, fully specified edits with cheap verification |
| Medium | Terra, Sonnet | Standard implementation, known-cause fixes, bounded refactors, ordinary analysis and drafting |
| High | Sol, Opus | Unknown-cause debugging, cross-file invariants, architecture, ambiguous synthesis, consequential review |
| Extra | Astra, Fable | The hardest long-horizon reasoning or autonomous work when high weight proves insufficient |

Use lower weights when failures are visible, reversible, and cheaply checked. Route upward when mistakes are hard to detect or costly to undo. Keep open-ended comprehension above low weight. Verify cheaper attempts before accepting them; escalate on a demonstrated reasoning gap rather than repeating failed attempts unchanged.

Choose effort independently:

- `low`: extraction, routing, routine rewrites, fully specified and checkable work.
- `medium`: standard coding, planning, and analysis balancing quality, speed, and cost.
- `high`: difficult diagnosis, reasoning, coding, or synthesis.
- `xhigh`: demanding long-running coding, design tradeoffs, or correctness-sensitive review.
- `max`: exceptional difficulty with evidence that the quality gain justifies the added time and cost.

Tune effort before changing weight for reasoning depth; increase weight for broader context or judgment. Reduce effort when exploration or overbuilding adds no value. Compare completed-task quality, time, and cost, including verification and retries.

Resolve the weight to an available model and supported effort using the host's controls. Family pairings are categories, not performance equivalences; respect version-specific capabilities. Return the concrete model, effort, and a brief task-based reason. Distinguish the requested selection from the actual model and effort reported by execution; mark unobservable values as unknown.
