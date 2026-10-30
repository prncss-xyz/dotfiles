# Precommit Reviewer

From the repository root, resolve the hook with `git rev-parse --git-path hooks/pre-commit`, which accounts for `core.hooksPath` and worktrees. If it is absent or not executable, report it as absent with the reason. Otherwise run it through Git:

```sh
git hook run pre-commit
```

Report validation status as passed, absent, or failed, with the command, exit status when run, and significant output. Always report files the hook modified, even when it passes. Compare tracked and untracked contents before and after; do not edit, stage, or restore files yourself.

Inspect the hook and its invoked configuration to establish what it checks. State whether each check covers the index, working tree, or another target, and whether that matches the pinned scope. A staged-only check does not establish coverage of unstaged or untracked changes; a working-tree check does not establish coverage of different committed contents. Mark coverage unknown when it cannot be established.
