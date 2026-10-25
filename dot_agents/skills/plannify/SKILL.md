---
name: plannify
description: Interview the user through a design tree, using subagents for facts, until no decision is left open
disable-model-invocation: true
---

This is a planning session: never implement the work.

Interview the user relentlessly, mapping the work as a **design tree** where every decision branches into the decisions that hang off it. Work in **rounds**: each round, ask the whole **frontier** — every open decision whose prerequisites are settled — in a single call to the harness's question tool (or a single message if it has none), then wait. Answers push the frontier outward; recompute and repeat. Stop descending a branch once the remaining choices are local, easily reversed, or wouldn't change what a reviewer approves — those are implementation details.

Decisions are the user's; facts are yours. When a question needs a fact from the environment, dispatch a subagent instead of asking — one exploring the codebase for local files, patterns, constraints, tests and integration points; one researching external docs and ecosystem context. Give each a specific prompt and ask for concise findings citing `path:line` or source URLs, separating what was verified from what was inferred, noting contradictions, and listing only the open questions that affect the design. If subagents can load skills, point the research one at the `research` skill. A running subagent only blocks the questions downstream of it; ask the rest of the frontier now.

Make sure these branches exist where relevant — they are the decisions most often left for the implementer to discover:

- **Ownership**: which component owns each responsibility and the key state.
- **Invariants**: what must hold throughout and after the change.
- **Composition**: where behavior lives, and whether locally sensible steps conflict when combined.
- **Evidence**: how tests will reach and demonstrate the intended behavior, not merely exercise nearby code.
- **Delivery**: which requirements are gates versus optional follow-ups, the first end-to-end outcome worth verifying, the order outcomes must land in, and what temporary scaffolding (stubs, flags, dual paths) is acceptable between them.
- **Prefactoring**: whether restructuring existing code first would make the change easier — raise it only when scouted evidence supports it.

Skip branches that don't apply.

When the frontier is empty, ask: what design decision would the implementer otherwise have to make alone? Each answer is a missing branch — add it to the tree and keep going.

When nothing remains, draft the plan: the desired outcome, scope (in and out), acceptance criteria, the resolved decisions and their rationale, and key risks. Keep it reviewable by a human: no slices, steps, or code — breaking the plan down is the job of the `decompose` skill.

Before saving, dispatch a reviewer subagent with the user's task, the draft, and relevant evidence. Ask it to check factual accuracy against the codebase and libraries, scope (nothing missing, nothing unrelated added), internal consistency, and simplicity, and to separate verified errors from uncertainty and preferences, citing the affected section and evidence. Fix valid findings; if one needs a new decision, return to the interview for it.

Write the plan to the suggested file or, if unspecified, `plan.md` in the artifacts directory. End by reporting the plan's path and suggesting to run `decompose` on it.

$@
