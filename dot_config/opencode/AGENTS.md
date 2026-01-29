# Instructions

## Agentic Search Protocol

Follow this routing logic for all information retrieval tasks:

- Documentation & API Truths: If the task involves specific library syntax, framework updates, or fixing potential hallucinations, ALWAYS use Context7. Prioritize this over general web searches to ensure version-accurate documentation.
- Semantic Research & Clean Context: Use Exa when seeking high-quality articles, "clean" code snippets without SEO noise, or when looking for concepts "similar to" a specific pattern (e.g., “Find a TS pattern similar to Rust’s Option type”).
- General Facts & Quick Snapshots: Use Tavily for broad, "state-of-the-world" queries, news, or non-technical general information where a quick summary is more efficient than a deep dive.
- Local Codebase Intelligence: For any query regarding the current project’s structure, function locations, or local implementations, use warp-grep. This allows for intelligent ripgrep operations that keep the main context window lean.
- Global Code Patterns: Use gh_grep to search public GitHub repositories when you need to see real-world implementations of a library or how other developers solve a specific architectural problem in the wild.

Warp Grep: warp-grep is a subagent that takes in a search string and tries to find relevant context. Best practice is to use it at the beginning of codebase explorations to fast track finding relevant files/lines. Do not use it to pin point keywords, but use it for broader semantic queries. "Find the XYZ flow", "How does XYZ work", "Where is XYZ handled?", "Where is <error message> coming from?"

## Coding

- Prefer functional programming over imperative programming.

## Fast Apply

IMPORTANT: Use \`edit_file\` over \`str_replace\` or full file writes. It works with partial code snippets—no need for full file content.
