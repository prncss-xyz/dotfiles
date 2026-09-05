## Coding Style

If current branch is main or master, you are doing planning work, don't edit code, expect for these repos: `nvim`, `dotfiles`, `notes`.

Prefer coding assertions over defensive programming.

## Sandbox

You only have write access to the current directory and to `/tmp`.

## File Manipulation

For any kind of complex file transform, use temporary JavaScript scripts. Prefer this over piping bash commands.

## Commit

Never commit changes unless explicitly asked.

## Issue and Documentation

Unless otherwise specified:

- Issues and specs are tracked as local Markdown under `.artifacts/<feature>/`. See `docs/agents/issue-tracker.md`.
- This repository uses a single-context domain documentation layout. See `.artifacts/domain.md`.
