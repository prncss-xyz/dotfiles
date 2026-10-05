---
name: my-plan
description: Define a high-level plan for a user task through a focused interview, then save it as an artifact.
disable-model-invocation: true
---

Plan the task supplied by the user in `$@`.

## 1

Interview the user until you share an understanding of the desired outcome, scope, and acceptance criteria. Map decisions and their prerequisites as a design tree. In each round, use the harness provided tool to ask all questions whose prerequisites are settled, number them, and give a recommended answer for each. Wait for the user's answers, then update the tree and ask the next round. Do not ask a question that depends on an answer still open in the current round.

Verify facts from the repository and available tools instead of asking the user for them. If a fact needs separate investigation, delegate it to a subagent and continue with questions that do not depend on it. Ask the user to make decisions, not to research facts. End the interview when no material decisions remain open and the user confirms the shared understanding.

## 2

Create or replace the artifact `plan.md`. Include the desired outcome, scope, a numbered breakdown, dependencies, checkpoints, acceptance criteria, and key risks. Keep it high level; omit implementation steps.

### Tracer bullets, not layers

Organize the breakdown into vertical slices: each slice delivers one thin, working path through all the layers needed for an observable outcome. Start with the smallest end-to-end path, then extend it with additional behavior. Do not split the work into horizontal phases such as all storage, then all backend, then all UI; that postpones verification until several phases land.

For each slice, state the outcome, scope across the necessary layers, acceptance criteria, and how it can be verified once its prerequisites have landed. A slice must own all work needed to meet its criteria; no criterion may depend on a later slice. For example, prefer “create and retrieve one saved item” followed by “list and filter saved items” over separate database, API, and UI phases.

Look for prefactoring that makes the change easier before planning feature slices. When justified by repository evidence, put that work before the slices it enables, give it its own behavior-preservation checks, and explain why it is needed. Do not invent a broad cleanup or infrastructure phase.

Record only real blocking dependencies and explain what each prerequisite supplies. If a slice cannot be verified without unfinished work elsewhere, merge the coupled work or redraw the boundary. Keep slices small enough to assess independently without fragmenting a single outcome into layer-specific tasks.

## 3

Launch a subagent with its own context. Give it the user's task, the draft plan, and relevant repository evidence. Ask it to review the plan along these axes:

- Factual accuracy: are the claims about the codebase and the libraries valid?
- Scope accuracy: does the plan cover the full task without adding unrelated work?
- Internal consistency: are some parts of the plan contradicting each other?
- Simplicity: can some aspects of the plan be made simpler?
- Vertical slicing: does each slice deliver a verifiable outcome across the necessary layers, own its acceptance criteria, and avoid depending on later work? Are prefactoring and blocking dependencies justified?

Require actionable findings with the affected plan section, supporting evidence, and a suggested correction. Have the reviewer distinguish verified errors from uncertainty and preferences, and identify claims it cannot verify.

## 4

Wait for the review. Verify findings and revise the plan to address valid issues. If a finding requires a new user decision, return to the interview for that decision before finalizing. Request a focused recheck only when revisions materially change the approach or leave a substantive finding unresolved.

## 5

Report the plan's location and stop. Do not begin executing the plan.
