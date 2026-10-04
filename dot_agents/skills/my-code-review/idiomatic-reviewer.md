# Idiomatic Reviewer

Review the change for idiomatic code and code quality. Leave other review concerns to the other reviewers.

Apply the following four sources of idiomatic guidance in descending priority. Also review the baseline code smells below.

## 1. Project Rules

Read project documentation such as `CONTRIBUTING.md` and `CODING_STANDARDS.md`. Also read any ADR or domain glossary for the area under review.

## 2. The Code Itself

Read two or three files similar to the code under review. Prioritize consistency with the codebase in naming, file layout, error handling, and module boundaries unless there is a reason to depart from it.

## 3. Stack Defaults

- [Front-End Design](./stacks/front-end-design.md)
- [React](./stacks/react.md)
- [TypeScript](./stacks/typescript.md)

## 4. Generic Best Practices

Prefer functional programming over imperative programming or OOP.

Prefer coding assertions over defensive programming.

Use explicit error handling patterns: avoid try/catch workflows and throw for code assertions.

### State Management

When many variables are not independent and only some combinations of values are possible, represent them with an algebraic data type.

When a boolean flag is only tested for a negative condition, rename it to its antonym and invert its meaning.

### Code Organization

When statement order does not matter, try to group conceptually related statements. For example, test a flag and change its value on adjacent lines.

### Testing

Remove old tests made redundant by new tests, for example when extracting functionality into a new module.

Never test what is prevented by types or API contracts.

Code assertions don't need to be tested.

A valid edge case must target code paths or parameter combinations specific to the code being tested. Do not test generic edge cases that are irrelevant to that code, such as blank spaces when whitespace has no bearing on its behavior.

### Comments

Use comments as a last resort, for information that cannot be expressed through naming, types, code assertions, or similar means.

## Baseline Code Smells

Use this fixed set of Fowler code smells (_Refactoring_, chapter 3). **Code smells require judgment.** Label each smell as a heuristic, such as "possible Feature Envy," rather than a hard violation. Match each smell against the diff. Each entry describes the smell and a possible remedy:

- **Mysterious Name**: a function, variable, or type whose name does not reveal what it does or holds. Rename it; difficulty finding an accurate name may indicate an unclear design.
- **Duplicated Code**: the same pattern of logic appears in more than one hunk or file in the change. Extract the shared logic and call it from both locations.
- **Feature Envy**: a method accesses another object's data more than its own. Move the method to the object whose data it uses.
- **Data Clumps**: the same fields or parameters repeatedly travel together. Bundle them into one type and pass that type.
- **Primitive Obsession**: a primitive or string represents a domain concept that deserves its own type. Give the concept its own small type.
- **Repeated Switches**: the same `switch` or `if` cascade on the same type recurs across the change. Replace it with polymorphism or one map shared by both locations.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. Gather code that changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. Split it so each module changes for one reason.
- **Speculative Generality**: abstractions, parameters, or hooks are added for needs absent from the spec. Remove them and inline the code until a real need arises.
- **Message Chains**: long navigation such as `a.b().c().d()` exposes a path the caller should not depend on. Hide the navigation behind one method on the first object.
- **Middle Man**: a class or function mostly delegates to another. Remove it and call the target directly.
- **Refused Bequest**: a subclass or implementer ignores or overrides most of what it inherits. Replace inheritance with composition.

## Reporting

Report findings by file/hunk:

- For every standard violation in the diff, cite the standard's file and rule, and quote the hunk.
- For each baseline smell, name the smell and quote the hunk.

Skip checks already enforced by tooling, for both documented standards and baseline smells. Distinguish hard violations of documented standards from judgment calls about baseline smells. Keep the report under 400 words.

Record any pre-existing issues unrelated to the task in `.artifacts/deferred-work.md`, creating the file if needed.
