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

## Critical Run Constraints

- Max 2 consecutive retries on the same tool validation error. If it fails twice, stop and report the error directly to the user.
- Max 1 shell command allowed before updating a checkpoint file or writing status.
- If a tool schema fails, explicitly state "Schema Failure" and request human intervention.
