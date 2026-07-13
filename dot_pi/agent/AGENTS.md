## Style

## Sandbox

You only have write access to the current directory and to `/tmp`.

## File manipulation

For any kind of complex file transform, use temporary JavaScript scripts. Prefer this over piping bash commands.

## Coding

- never commit changes unless explicitly asked to
- prefer functional programming over imperative programming or OOP

### Typescript

- don't write an explicit return type to functions unless it differs from inferred type
- prefer named imports over namespace imports (`import { useState } from "react` over `import * as react from 'react'`)
