---
description: Commit changes
agent: build
model: gemini-3-flash-preview
---

Generate a commit message and perform the commit following these rules explicitly:

Analyze the changes and generate a proper commit message.

Use Conventional Commits v1.0.0 format with this structure: `type(scope): description`

Use only these types:

    feat: New feature or functionality
    fix: Bug fix
    docs: Documentation-only changes
    style: Code style changes (no logic change)
    refactor: Code changes neither fixing bug nor adding feature
    perf: Performance improvements
    test: Adding or correcting tests
    build: Changes to build system, dependencies, CI/CD
    chore: Maintenance, tooling, config
    ci: CI configuration and scripts
    revert: Reverting a previous commit

Never invent new types; use chore as fallback.

Scope: lowercase, hyphenated (e.g., (auth), (ui/login)); reflect module/component/domain.

Description: Imperative present tense (add, fix, update), start lowercase, no period. Must not exceed 50 characters. Must not repeat the

Self-check: Valid prefix, lowercase scope, summary rules.

Ask the user if the generated commit message is acceptable and then perform the git commit with the message if approved.

A commit that introduce breaking changes must be indicated by an `!` before the `:` in the subject line e.g. `feat(api)!: remove status endpoint`

Use tools to read the content of the files if needed.

Changed files are:

!`git status -s`
