---
name: prep
description: Prepares the development environment — toolchain via mise, dependencies, prepare (idempotent) and doctor. Use when cloning a repo or when the environment is broken.
allowed-tools: Bash, Read
user-invocable: true
---

# Prepare Development Environment

Global skill — if the repo has its own `prep` skill, it wins.

Standard flow, in this order:

```bash
mise install          # toolchain (versions of node, pnpm, go, etc.)
pnpm install          # dependencies (if a Node project; otherwise, the stack's equivalent)
mise run prepare      # project setup (lefthook hooks, codegen, etc.)
mise run doctor       # diagnostics: validates that the environment is healthy
```

Skip any step whose task doesn't exist in the repo (`mise tasks` lists what's
there), but **always run `doctor` when it exists** — it's what confirms the
prep worked.

## Rules

- **`prepare` must be idempotent**: running it again must not break anything
  or duplicate effects. If, when creating/editing a `prepare` task, it isn't
  idempotent, fix that.
- Never install a dependency with npm/yarn in a pnpm project; never install
  a toolchain outside of mise.

## Afterwards

1. If there were errors, explain what happened (the `doctor` output is the
   guide).
2. If everything worked, suggest bringing up the full environment (`tilt up`
   or `mise run dev`, depending on the repo).
