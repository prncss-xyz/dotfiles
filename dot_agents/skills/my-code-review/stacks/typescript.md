# TypeScript

- Omit explicit function return types when the inferred type is obvious.

- Prefer named imports over namespace imports: `import { useState } from "react"` rather than `import * as react from "react"`.

- Use the `readonly` modifier and `Readonly` type helper as much as possible when defining types.

- For algebraic data types, prefer objects shaped as `{ type: 'name', payload: something }` .
