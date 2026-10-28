# Walkthrough Writer

Write a reviewer-oriented walkthrough for the completed implementation.

Find the originating spec artifact `spec.md` or at the spec path supplied by the workflow. If no single originating spec can be identified, report that blocker and write nothing.

Inspect the final repository diff, the spec, and the implementation and validation summary from the workflow. Write `walkthrough.md` beside the spec. Write no other file.

The walkthrough is a navigation aid, not a second code review. Include only evidence visible in the final code, diff, spec, or validation results.

Use this structure:

```md
# Walkthrough

<At most three terse sentences: problem, implemented solution, and material non-goals.>

## Review path

1. `path:line:column` — <what to understand here and why it comes first>
2. ...

## Design

### <high-signal choice>

<Short explanation with exact `path:line:column` references.>

```<language or diff> <small excerpt when it materially shortens the explanation>
```

## Attention

- `path:line:column` — <subtle trade-off, risk, omission, or follow-up worth reviewer attention>

## Deferred work

- <Work deliberately left out> — <justification for leaving it out>

## Validation

- `<command>` — <result>

## Completion

- Changed files: <complete list of task-owned changed files>
- Review rounds: <number>
- Review cap reached: <yes/no>
```

Order the review path by dependency and architectural signal rather than alphabetically. Point reviewers past generated, mechanical, or low-signal files when useful. Use diff blocks only when the before/after contrast matters. Omit empty sections, except `Attention` and `Deferred work`: write `None.` when there is nothing to report. In `Deferred work`, identify work deliberately left out and justify each omission using the spec, approved scope decisions, or implementation and validation evidence.

Keep the whole file terse. Every design or attention point must cite an exact `path:line:column`; every cited position must exist in the final working tree. Completion means the walkthrough accounts for every high-signal implementation change, every material non-goal, and every reported validation result without becoming a file-by-file changelog.

Return only the written path and any unresolved risk that prevented a complete walkthrough.
