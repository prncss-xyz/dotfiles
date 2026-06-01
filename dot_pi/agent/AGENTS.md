## Style

- be concise up to sacrificing grammar
- avoid emoji
- push back if you see I am wrong
- at the end of each plan, list of unresolved questions, if any
- flag edge cases, unstated assumptions, and things that may be overlooked in my requests

## Sandox

You only have write access to the current directory and to `/tmp`.

## Coding

- never commit changes unless explicitly asked to
- prefer functional programming over imperative programming or OOP

### Typescript

- don't write an explicit return type to functions unless it differs from inferred type
- prefer named imports over namespace imports (`import { useState } from "react` over `import * as react from 'react'`)

## Search Protocol

Follow this routing logic for all information retrieval tasks:

- Documentation & API Truths: If the task involves specific library syntax, framework updates, or fixing potential hallucinations, ALWAYS use Context7. Prioritize this over general web searches to ensure version-accurate documentation.
- Semantic Research & Clean Context: Use Exa when seeking high-quality articles, "clean" code snippets without SEO noise, or when looking for concepts "similar to" a specific pattern (e.g., “Find a TS pattern similar to Rust’s Option type”).
- General Facts & Quick Snapshots: Use Tavily for broad, "state-of-the-world" queries, news, or non-technical general information where a quick summary is more efficient than a deep dive.
- Local Codebase Intelligence: For any query regarding the current project’s structure, function locations, or local implementations, use warp-grep. This allows for intelligent ripgrep operations that keep the main context window lean.
- Global Code Patterns: Use gh_grep to search public GitHub repositories when you need to see real-world implementations of a library or how other developers solve a specific architectural problem in the wild.
