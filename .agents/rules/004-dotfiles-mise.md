---
trigger: always_on
---

# Install via `./dotfiles`, dev tasks via `mise`

## Installation (end use)

- To apply the dotfiles use **`./dotfiles`** directly. No `mise` needed to
  install.

## Development tasks

- Use **`mise`** for lint, tests and debug. NEVER use npm/pnpm/yarn (this
  project is shell, not Node).

### Correct

```bash
mise run lint
mise run test
mise run debug:linux:gui
mise run debug:linux:nogui
```

## Tasks are FILE-BASED

- Tasks live in **`.config/mise/tasks/`** (directory structure).
- NEVER define tasks inside `mise.toml`.

## Shell / Lint

- Every script must pass `mise run lint` (shellcheck, `shell=bash`).
- Always quote variables: `"$VAR"`, not `$VAR`.
- Prefer the modern Rust alternatives: `fd` (not `find`), `rg` (not
  `grep`), `sd` (not `sed`), `bat` (not `cat`) in `home/.bin/` scripts.
- When using `sd`/`rg` with single quotes, annotate
  `# shellcheck disable=SC2016`.
