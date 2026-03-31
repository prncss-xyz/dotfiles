# Instructions

## Agentic Search Protocol

Follow this routing logic for all information retrieval tasks:

- Documentation & API Truths: If the task involves specific library syntax, framework updates, or fixing potential hallucinations, ALWAYS use Context7. Prioritize this over general web searches to ensure version-accurate documentation.
- Semantic Research & Clean Context: Use Exa when seeking high-quality articles, "clean" code snippets without SEO noise, or when looking for concepts "similar to" a specific pattern (e.g., “Find a TS pattern similar to Rust’s Option type”).
- General Facts & Quick Snapshots: Use Tavily for broad, "state-of-the-world" queries, news, or non-technical general information where a quick summary is more efficient than a deep dive.
- Local Codebase Intelligence: For any query regarding the current project’s structure, function locations, or local implementations, use warp-grep. This allows for intelligent ripgrep operations that keep the main context window lean.
- Global Code Patterns: Use gh_grep to search public GitHub repositories when you need to see real-world implementations of a library or how other developers solve a specific architectural problem in the wild.

## Coding

- Prefer functional programming over imperative programming.
- In typescript, when importing functions, prefer named imports e.g. `useState` vs `React.useState`.
