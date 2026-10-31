# Post-style

Read-only: don't modify files or launch subagents. Check the style-fix changes between the supplied snapshot and current state against the supplied findings, validation, and hook results. Inspect surrounding code as needed. Don't reopen the task review or add style preferences.

Return a brief summary of what you inspected, plus one of:

- `pass`: every finding is resolved, and the changes are purely stylistic, preserve behavior, and touch nothing else. Passing tests support this but don't prove it.
- `fail`: unresolved findings, unrequested style changes, or behavior changes, each with `path:line` and a specific correction.
- `incomplete`: the missing evidence.
