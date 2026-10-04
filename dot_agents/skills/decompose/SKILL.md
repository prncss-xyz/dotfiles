---
name: decompose
description: Decompose a high level plan into actionable steps
disable-model-invocation: true
---

Decompose the task supplied by the user in `$@`. You will write the result to an artifact file named `todo.md`. If the file already exits, say so and don't proceed further.

## 1

Decompose the task in vertical slices.

Sort them such that:

- When a slice have dependencies, the dependencies come first in the list.
- As much as the dependency requirement is respected, the simplest slices go first.

Each vertical slice is a markdown section.

## 2

Decompose each vertical slices into atomic steps. Order each step in such a way that

- When a step have dependencies, the dependencies come first in the list.
- As much as the dependency requirement is respected, the simplest steps go first.

The atomic steps for a given vertical slice appears as mark down TODO like `- [ ] {step}`
