---
name: create-task
description: Create artifact tasks (task.md files) that show up in the neoterm task panel and can be run as steps or auto steps. Use when asked to create, file, queue, or schedule a task, todo, or follow-up for later work.
---

Create one or more tasks in the artifacts tree. A task is a markdown file; the neoterm task panel watches the tree and picks new files up on its own, so writing the file is the whole job. Never create git branches or worktrees: steps do that when the task runs.

## Location

The artifacts root is `~/projects/notes/main/dev/artifacts`. Tasks for a project live under `<root>/<project>/`, where `<project>` is the directory name directly under `~/projects` (for `~/projects/nvim/main` it is `nvim`). Group related tasks in subdirectories when that helps (for example `<root>/utils-mono/stores/`). Unless told otherwise, put the task under the project of the current working directory, or beside the plan or task it derives from.

A task has one of two shapes:

- **Directory task**: `<dir>/<name>/task.md`. Use it when the task will gather step outputs (`plan.md`, `implementation.md`, `merge.txt`, …) or when it runs steps; auto steps only trigger on directory tasks.
- **Flat task**: `<dir>/<name>.task.md`. Use it for a short todo or note that needs no companion files.

Never create both shapes with the same name in the same directory: the panel reports it as `ERROR:DUPLICATE`.

## Name

`<name>` is `<number> <title>` or just `<title>`.

- `<title>` is the source of the commit message and branch name, so keep it to 1–4 lowercase words, spaces allowed. Coding titles start with a conventional commit prefix (`feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`, `build`, `ci`, `style`, `revert`); without one, `feat` is assumed. Non-coding titles start with `todo`; it is not a recognised prefix, so such a task would be committed as `feat`. Give `todo` tasks no steps that commit. Examples: `feat dark mode`, `fix search`, `todo meeting amanda`.
- `<number>` is optional and orders siblings: one or more digit groups separated by single spaces (`01`, `015`, `0 0`, `0 05`), using only digits and spaces. It is stripped when deriving the commit message and branch name, so its shape can change freely. Example series: `01 feat parser`, `02 feat printer`.

If the name already exists in the directory, append `-000`, `-001`, … to the title.

## Order

Auto mode runs sibling tasks in byte-wise order of their names (plain string comparison, like `LC_ALL=C sort`; no numeric parsing), and runs a task's subtasks before the task itself. Space < digits < uppercase < lowercase, so `0 x` < `00 a` and `05` > `0 x`.

Never rename existing tasks; place a new one by choosing its number only, and never give two siblings the same number:

- **After the last task `L`:** increment `L`'s number keeping its width (`03` → `04`, `09` → `10`). If it can't grow without widening (`99`), append a digit (`995`).
- **Before the first task `F`:** prefix `F`'s number with `0 ` (`00 a` → `0 00 x`, `0 x` → `0 0 x`). If `F` has no number, use `0`.
- **Between adjacent tasks `A` and `B`:** take the middle unused number at the same width if there is one (`01` and `05` → `03`). Otherwise append a digit directly to `A`'s last digit group, with no space (`01` and `02` → `015`, `0 0` and `0 1` → `0 05`, `015` and `02` → `0155`); `01 5 x` would sort before `01 a`.

Before creating the task, check that it lands where intended:

```sh
printf '%s\n' "00 a" "0 00 x" "01 b" | LC_ALL=C sort
```

## Contents

Decide where the description goes:

- **Ready to implement**: the task is detailed enough to be implemented as is. Make it a directory task and write the description to `<name>/plan.md`. Leave out `task.md`, or, when frontmatter is needed, write a `task.md` that holds only the frontmatter and an empty body.
- **Needs clarification**: the task still needs clarification work with the user. Write the description in `task.md` (or `<name>.task.md`).

A `task.md` with a description looks like this:

```markdown
---
status: ready
dependencies:
  - ./01 feat parser.task.md
auto: implementation:claude
---

# Outcome stated in one line

What to do, with links to the relevant plan, files, and prerequisites, so the task can be understood without this conversation.
```

`plan.md` takes the same body, without frontmatter. All frontmatter fields are optional; omit the frontmatter block entirely when none apply.

- `status`: one of the enabled statuses in `tasks.status` of `~/projects/nvim/main/lua/neoterm/config.lua`, in workflow order: `maybe`, `later 2`, `later 1`, `later 0`, `explore`, `inbox`, `deferred`, `ready`, `blocked`, `active`, `review`, `merging`, `done`, `aborted` (plus machine-specific ones gated by `work`/`personal` there). Defaults to `ready`; use `inbox` for things the user still has to triage. An unknown value shows up as `ERROR:UNKNOWN TAG`.
- `dependencies`: tasks that must reach `done` first. While one is not done, a task whose status is before `blocked` is shown as `blocked`. Each entry is the path of the dependency's task file, written as `./…` (relative to the task's own directory: the `<name>/` folder for a directory task, the containing folder for a flat task; `..` is not allowed), `~/…`, an absolute path, or a path relative to `~/projects/notes/main` (for example `dev/artifacts/nvim/feat x/task.md`). To depend on a sibling directory task, use the `~/` form. Cycles show up as `ERROR:CIRCULAR DEPENENCIES`.
- `auto`: `<step>` or `<step>:<variant>`, the step auto mode runs on this task. Step names are the `name`s in `steps` of the same config file (`plan`, `decompose`, `api-contract`, `implementation`, `do`, …); a variant is an agent name from `agents` (`claude`, `codex`, `pi`, …) and defaults to the step's first variant. Only set it when asked to queue the task for automatic execution.

## Report

List the paths of the files you created, with their status and any dependencies.
