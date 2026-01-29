# Instructions

## Search

- To search information about a TypeScript or JavaScript library, use Context7.
- To search information about the inner workings of a library or undocumented features, use the `gh_grep`.
- To search for use examples or code patterns examples, use `gh_grep`
- To search for generic information about a topic, use Tavily.
  When a search do not return useful results, do a second search with Google.

Warp Grep: warp-grep is a subagent that takes in a search string and tries to find relevant context. Best practice is to use it at the beginning of codebase explorations to fast track finding relevant files/lines. Do not use it to pin point keywords, but use it for broader semantic queries. "Find the XYZ flow", "How does XYZ work", "Where is XYZ handled?", "Where is <error message> coming from?"

## Coding

- Prefer functional programming over imperative programming.

## Fast Apply

IMPORTANT: Use \`edit_file\` over \`str_replace\` or full file writes. It works with partial code snippets—no need for full file content.
