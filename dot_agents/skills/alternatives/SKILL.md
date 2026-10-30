---
name: alternatives
description: "Read a problem or spec, compare its proposed implementation with five broad alternatives, and write a concise ranked alternatives document."
disable-model-invocation: true
---

# Implementation Alternatives

Use the invocation arguments to locate the source problem/spec and the requested output file. When the output path is omitted, write `alternatives.md` beside the source file.

## Process

1. Read the source document. Inspect only the nearby code and project documentation needed to understand the constraints and the implementation already proposed.

2. Generate exactly five meaningfully different implementation strategies. Keep them at the architectural or design-approach.

3. Rank the baseline and five alternatives from best to worst for this specific problem.

4. Write the requested output file using this shape:

```markdown
# Implementation Alternatives

## 1. <strategy name> — Recommended

<Only a few sentences describing the broad approach and why it ranks here. State when this is the baseline from the source.>

### Pros

- <brief point>
- <brief point>

### Cons

- <brief point>
- <brief point>

## 2. <strategy name>

...

## 6. <strategy name>

...
```

Each strategy gets only a few descriptive sentences and a few short pros and cons.
