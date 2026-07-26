---
name: new-task
description: Creates a new file-based mise task following the personal standard (executable bash script in .config/mise/tasks/)
argument-hint: [task-name]
allowed-tools: Read, Write, Bash
user-invocable: true
disable-model-invocation: true
---

# Create New Mise Task

Tasks are **executable files** (bash scripts) — NEVER defined in
`mise.toml` or in `package.json` `scripts`.

## Location

| Scope | Path |
|--------|---------|
| Repo root | `.config/mise/tasks/` |
| Per module (monorepo) | `apps/web/.config/mise/tasks/`, `packages/x/.config/mise/tasks/` |
| Hierarchical | `tasks/group/subtask` → `mise run group:subtask` |

In a monorepo, a module task runs with `mise run //path/to/module:task`
(separator `:`, never `/`).

## Template

Create the file at `.config/mise/tasks/[name]` (no `.sh`/`.bash` extension):

```bash
#!/usr/bin/env bash
#MISE description="Short description of the task"

set -euo pipefail

# Your code here
```

Make it executable: `chmod +x .config/mise/tasks/[name]`.

## Conventions

1. `#MISE description="..."` on line 2 (**required** — shows up in
   `mise tasks`).
2. `set -euo pipefail` on line 3 (fail fast).
3. The task runs **from the directory where it is defined** — compute the
   root if needed (`ROOT_DIR`).
4. Long-running/preparation tasks must be **idempotent** (running twice
   doesn't break) — required for `prepare`.
5. Shell: follow shellcheck; quote variables (`"$VAR"`); prefer `fd`/`rg`/`sd`
   over `find`/`grep`/`sed` when installed by the project.

## Verify

```bash
mise tasks            # the task shows up with its description
mise run [name]       # it works
```
