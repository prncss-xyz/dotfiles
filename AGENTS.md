When automation, create POSIX compliant shell scripts.
Only write shell functions for integration with fish shell (e.g. changing directory).

## What This Is

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). The source directory is `~/projects/dotfiles` (not the default `~/.local/share/chezmoi`). Files here use chezmoi naming conventions (`dot_`, `private_`, `executable_`, `.tmpl`) and are applied to the home directory. Never directly change the attributes of a file, use these prefix instead.

## Template System

Files ending in `.tmpl` are Go templates processed by chezmoi. Available data variables (from `.chezmoi.toml.tmpl`):

- `.hostname`, `.hosted` (bool as string), `.chezmoi.os` (`linux`/`darwin`)
- `.username`, `.fullname`, `.email`, `.github_user`, `.git_signkey`

Secrets are retrieved at apply-time via `pass` (passwordstore). OS-conditional blocks use `{{ if eq .chezmoi.os "darwin" }}` / `{{ if ne .chezmoi.os "darwin" }}`. The `.hosted` flag distinguishes hosted/cloud machines from local desktops.

## Repo Layout

- `dot_config/` — XDG config: fish shell, git, neovim (symlinked), ghostty, mango-wc, yazi, starship, etc.
- `dot_config/fish/conf.d/env.fish.tmpl` — environment variables and PATH setup
- `dot_config/fish/config.fish` — interactive shell: abbreviations, theme, tool init (fzf, starship, zoxide)
- `private_dot_local/bin/` — user scripts (chezmoi `executable_` prefix) must be standard POSIX-COMPLIANT scripts
- `scripts/post-install.fish.tmpl` — post-install setup: global packages (pnpm, uv), GPG key import, service links
- `scripts/post-install-root.fish` — root-level setup: sysfiles sync, runit services, font config
- `sysfiles/` — system-level config files synced to `/` via `rsync` (only on non-hosted machines)
- `.chezmoiignore` — conditional ignores per OS and hosted status

## Environment

- Primary shell: **fish**
- Primary OS: **Void Linux** (runit init, xbps package manager); also targets macOS and Alpine
- Editor: **neovim** (config lives in a separate repo, symlinked via `dot_config/symlink_nvim.tmpl`)
- Global JS packages managed via **pnpm**; Python tools via **uv**; npm prefix set to `~/.local`
- GPG signing enforced on all git commits and tags

## Scripts

When writing bash scripts, always make them POSIX-compliant.
