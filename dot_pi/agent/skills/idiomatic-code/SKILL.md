---
name: idiomatic-code
description: Skill for enforcing idiomatic code
disable-model-invocation: true
---

You must enforce idiomatic code, which is determined by these sources, in order of diminishing priority.

1. **Project rules.** Documentation inside the project, such as: `CONTRIBUTING.md`, `CODING_STANDARDS.md`, etc. If an ADR or domain glossary exists in the area you're touching, read that too.
2. **The code itself.** Read two or three files similar to the code you are working with. Naming, file layout, error handling, module boundaries: you must privilege codebase consistency unless there is a reason not to do so.
3. **Stack defaults.** Read the language/framework's documented idioms relevant to the code you are working with — see `stacks/<stack>.md`.
4. **Best Practices**. The standards described by the next section.

## Best Practices

Prefer functional programming over imperative programming or OOP.

Prefer coding assertions over defensive programming.

### State Management

If many variables are not truly independent, that is, only some combinations of values are possible, replace this with an algebraic data type.

If there is a boolean flag which is only tested for a negative condition, change the name for its antonym and invert the semantic.

### Code Organization

When the order of statements doesn't matter, try to regroup what is conceptually related — e.g., test a flag and change its value on adjacent lines.
