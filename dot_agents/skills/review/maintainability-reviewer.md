# Maintainability Reviewer

Review behavior-preserving improvements to readability, consistency, responsibilities, interfaces, ownership, and abstractions. Behavioral defects belong to correctness; requirement coverage and scope belong to intention.

## Sources

Apply these sources in order; higher-priority guidance overrides lower-priority guidance.

1. **Project documentation**: `CONTRIBUTING.md`, coding standards, and any ADR or domain glossary covering the changed area.
2. **The code itself**: two or three comparable files, for naming, file layout, error handling, and module boundaries. Prefer consistency with them unless there is a reason not to.
3. **Language and framework idioms** relevant to the changed code. Read the stack files next to this one that match the change, and only those:
   - [stacks/typescript.md](./stacks/typescript.md): TypeScript or JavaScript
   - [stacks/react.md](./stacks/react.md): React components or hooks
   - [stacks/front-end-design.md](./stacks/front-end-design.md): user-facing UI or styling
4. **Local practices** and **structural heuristics** below.

## Local practices

Bold names here and below are Fowler code smells (_Refactoring_, ch.3).

- **Mysterious Name**: clarify function, variable, or type names that obscure purpose.
- Name a boolean flag that is only tested negatively for its antonym, inverting its meaning.
- Reduce unnecessary nesting and simplify control flow.
- Replace overly clever or dense expressions with explicit, readable code.
- When statement order does not matter, group conceptually related statements.
- Prefer code assertions over defensive programming.
- Use explicit error handling; throw only for code assertions, never for try/catch control flow.
- Reserve comments for what naming, types, and code assertions cannot express.
- Remove tests made redundant by new ones. Do not test what types, API contracts, or code assertions already prevent. Edge cases must target code paths or argument combinations specific to the code under test.

## Structural heuristics

- **Duplicated Code**: remove local redundancy; consider extraction when shared ownership would prevent divergence.
- **Feature Envy**: behavior depends more on another object's data than its own.
- **Data Clumps**: the same fields or parameters repeatedly travel together.
- **Primitive Obsession**: primitives obscure a domain concept that warrants its own type.
- **Repeated Switches**: repeated branching on the same type or discriminator.
- **Shotgun Surgery**: one logical change requires scattered edits.
- **Divergent Change**: one module changes for several unrelated reasons.
- **Speculative Generality**: abstractions or extension points serve no current requirement.
- **Message Chains**: callers depend on a long navigation through objects.
- **Middle Man**: a class or function mostly delegates without adding useful responsibility.
- **Refused Bequest**: an implementer ignores or overrides most inherited behavior.

Prefer functional programming over imperative code or OOP, and model variables that are not truly independent, where only some combinations of values are valid, as an algebraic data type.

## Reporting

Only explicit user or repository rules establish hard violations: cite the instruction or file and rule. The bundled stack guidance, local practices, and structural heuristics are default preferences, even when phrased imperatively. Treat those and other undocumented choices as judgement calls; label them as such and name any applicable smell.

For each judgment call, explain the concrete maintenance cost in the changed code and how the proposed change reduces it.

Recommend changes only when they provide a concrete readability or maintenance benefit. Preserve useful abstractions; avoid unnecessary types, extraction, polymorphism, or combining unrelated concerns.
