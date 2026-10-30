# TypeScript

Don't write an explicit return type to functions if inferred type is obvious.

Prefer named imports over namespace imports (`import { useState } from "react"` over `import * as react from 'react'`).

When defining types, use `readonly` modifier and `Readonly` type helper as much as possible.

The preferred form for algebraic data types is
an object of the shape `{ type: 'name', payload: something }`.
