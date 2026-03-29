---
description: Commit and push changes using Conventional Commits
---

!`git add --all`

# Git Status

!`git status`

# Staged Changes

!`git diff --staged`

1. Analyze the `Git Status` and `Staged Changes` above.
2. Draft a commit message following the **Conventional Commits** specification:
   - Format: `<type>(<scope>): <description>`
   - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `revert`.
   - Scope is optional but recommended if applicable.
   - Description should be concise and in the imperative mood.
3. Create the commit using `git commit -m "<message>"`.
4. Push the changes to the remote repository using `git push`.
5. Verify the success of both operations and report back.
