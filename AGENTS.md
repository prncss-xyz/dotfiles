# Agent Guidelines for Chezmoi Dotfiles

This repository contains the user's dotfiles managed by [chezmoi](https://www.chezmoi.io/).
As an agent operating here, you must follow these guidelines to ensure system stability,
maintainability, and security.

## 1. Repository Context

- **Core Tool:** `chezmoi` is used to manage files. The source state is in this directory,
  and the destination state is the user's home directory (`~`).
- **Primary Shell:** The user heavily utilizes **Fish** shell (`~/.config/fish`), though
  standard POSIX scripts and Bash configurations (`.bashrc`) are also present.
- **Environment:** This is a multi-system configuration. Main environment is Voidlinux.
  Window managers include `river` and `sway`.

## 2. Build, Test, and Deploy Commands

Since this is a configuration repository, "building" implies applying the configuration to the local system.

### Verification (The "Test" Phase)
Before applying any changes, ALWAYS perform a dry run to see what would happen.
This is the equivalent of running tests.

```bash
# Check what changes would be made without applying them
chezmoi apply --dry-run
```

To verify a specific file:
```bash
chezmoi apply --dry-run --verbose ~/.config/path/to/file
```

### Application (The "Build/Deploy" Phase)
Only apply changes after verifying the dry run or if explicitly instructed.

```bash
# Apply all changes to the home directory
chezmoi apply

# Apply changes for a specific file only (Safer)
chezmoi apply ~/.config/path/to/file
```

### Linting
There are no enforced CI linters, but you should adhere to these standards:
- **Shell Scripts:** Ensure syntax validity. Use `shellcheck` logic for Bash/Sh.
- **Fish Scripts:** Ensure valid Fish syntax (`fish -n script.fish`).
- **YAML/JSON/TOML:** Ensure valid syntax.

## 3. Code Style & Conventions

### Chezmoi Conventions
- **Source Files:**
  - Files starting with `dot_` map to `.` (hidden files) in the home directory.
    - Example: `dot_bashrc` -> `.bashrc`
  - Files starting with `executable_` map are executable (0755).
  - Files starting with `private_` have restricted permissions (0600).
    - Example: `private_dot_ssh/config`
  - Files ending in `.tmpl` are Go templates.
    - **CRITICAL:** Preserve existing template logic (`{{ ... }}`).
    - **CRITICAL:** Do not break OS-specific checks if they exist.

### Shell Scripting
- **Fish (Preferred):** For user-facing scripts or interactive shell config, use Fish.
  - Indentation: 4 spaces (standard for Fish).
  - Naming: Kebab-case for functions and files (e.g., `my-function.fish`).
- **Bash/Sh (Compatibility):** Use for strictly POSIX-compliant needs or `bashrc`.
  - Indentation: 2 or 4 spaces (match the file).
  - Shebang: Always include `#!/bin/bash` or `#!/bin/sh` for executable scripts.
  - Quoting: Quote variables `"$VAR"` to prevent whitespace splitting issues.

### Configuration Files
- **Comments:** Comment heavily for complex configurations (e.g., `sway`).
  Explain *why* a setting is chosen, not just what it is.
- **Formatting:**
  - **Lua:** (Neovim/Hammerspoon) Use standard Lua formatting (2 spaces).
  - **TOML/YAML:** standard 2-space indentation.
- **Imports/Includes:** If a config file supports splitting (like `source` in shell or `include` in sway),
  prefer breaking large files into smaller logical units in a subdirectory (e.g., `conf.d/`).

## 4. Working with Templates

When editing `.tmpl` files, recognize the context:
```
{{- if eq .chezmoi.os "linux" -}}
# Linux specific config
alias ls='ls --color=auto'
{{- end -}}
```
- **Do not** remove these guards unless you are certain the config applies everywhere.
- **Do not** introduce hardcoded paths that might differ between machines unless wrapped in logic.

## 5. Directory Structure Map

- `dot_config/`: Main configuration directory (`~/.config`).
  - `fish/`: Fish shell configuration.
  - `river/`: River window manager config.
  - `sway/`: Sway window manager config.
  - `opencode/`: Opencode-cli configuration.
  - `nvim/`: Neovim configuration.
  - `waybar/`: Status bar configuration.
- `scripts/`: Utility scripts for maintenance or installation.
- `dot_local/bin/`: Local user scripts.
- `dot_ssh/`: SSH configuration (Handle with extreme care).

## 6. Safety & Security Guidelines

1.  **Secrets:** NEVER write secrets (API keys, passwords, private keys) directly to the repo.
2.  **Destructive Actions:**
    - never call chezmoi apply or chezmoi update.
3.  **Idempotency:**
    - Scripts in `run_onchange_` or `run_once_` should be idempotent.
    - Example: Don't append to a file blindly; check if the line exists first (or let chezmoi handle the file content entirely).

## 7. Workflow for Agents

1.  **Explore:** Use `ls` and `grep` to locate the relevant config file in the source directory (`dot_...`).
2.  **Read:** Read the content. Check if it is a template (`.tmpl`).
3.  **Edit:** Modify the source file.
    - *Note:* Do not edit the file in `~/.config` directly if you are asked to "update the repo". Edit the file here in the chezmoi source.

## 8. Common Gotchas

- **File Renaming:** If you rename a source file, you must use `git mv` (if tracked) or handle the old file.
  Remember `dot_` maps to `.`!
- **Permissions:** If a file needs to be executable, generally git tracks the executable bit, but chezmoi also respects `executable_` prefix.
  - Example: `executable_scripts/my-script.sh` ensures it lands as `+x`.
- **Symlinks:** `symlink_` prefix creates symlinks.
