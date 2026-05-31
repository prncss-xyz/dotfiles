## Babysitter

This project uses [Babysitter](https://a5c.ai) for workflow orchestration. Babysitter helps automate and manage dotfile maintenance workflows.

### Babysitter Commands

- `babysitter harness:call` — Start an interactive babysitter run
- `babysitter harness:yolo` — Start a non-interactive babysitter run
- `babysitter harness:project-install` — Rerun project setup

### Recommended Processes

- `cradle/project-install` — Project setup and onboarding (already configured)
- `gsd/discuss` — Discuss and plan dotfile changes before executing
- `gsd/execute` — Execute routine dotfile updates with orchestration
- `gsd/audit` — Audit dotfile state and consistency across machines

### Methodology

Use **gsd (Get Stuff Done)** — lightweight workflow suitable for dotfiles maintenance.

### Profile

Project profile stored at `.a5c/project-profile.json`. Run state stored in `.a5c/runs/`.
