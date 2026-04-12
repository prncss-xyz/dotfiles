# Instructions

## Agentic Search Protocol

Follow this routing logic for all information retrieval tasks:

- **Documentation & API Truths**: Use Context7 for specific library syntax, framework updates, or fixing potential hallucinations. Prioritize this over general web searches for version-accurate documentation.
- **Semantic Research & Clean Context**: Use Exa for high-quality articles, "clean" code snippets without SEO noise, or when looking for concepts "similar to" a specific pattern.
- **General Facts & Quick Snapshots**: Use Tavily for broad "state-of-the-world" queries, news, or non-technical general information.
- **Local Codebase Intelligence**: Use warp-grep for queries about the current project's structure, function locations, or local implementations.
- **Global Code Patterns**: Use gh_grep to search public GitHub repositories for real-world implementations of a library or how other developers solve specific architectural problems.

## Coding

- Prefer functional programming over imperative programming.
- In TypeScript, when importing functions, prefer named imports e.g. `useState` vs `React.useState`.