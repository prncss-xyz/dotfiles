# Precommit Reviewer

Resolve the precommit hook from the repository root, respecting `core.hooksPath` and worktrees:

```sh
git rev-parse --git-path hooks/pre-commit
```

Run the resolved hook if it exists; otherwise skip it. Hook changes to files are allowed. Report failures to the parent so it can capture the updated review scope. Do not make additional edits yourself. Report whether the hook passed, failed, or was skipped; a missing hook is not a finding.
