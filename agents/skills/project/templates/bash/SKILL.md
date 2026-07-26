---
name: bash
description: Personal shell script standards — bash with clean shellcheck, rigorous quoting, set -euo pipefail, modern CLIs (fd/rg/sd/bat), idempotency. Use when writing or reviewing shell scripts.
allowed-tools: Read, Grep
---

# Bash — personal standards

Global skill — if the repo has its own shell conventions, they win.
Bash is (along with TypeScript) the default language for new scripts.

## Skeleton

```bash
#!/usr/bin/env bash
# Purpose comment at the top (the "why" of the script)

set -euo pipefail
```

In mise tasks, the 2nd line is `#MISE description="..."` (skill `new-task`).

## Shellcheck rules (must pass clean)

- **Always quote variables**: `"$VAR"`, never `$VAR`; in expansions too:
  `"${var%-"${OS}"}"`.
- `grep -q` instead of `[ -n "$(grep ...)" ]`.
- Group redirects: `{ cmd1; cmd2; } >> file`.
- `continue` only inside a loop.
- Optional source: annotate `# shellcheck disable=SC1091`.
- `sd`/`rg` with single quotes containing `$`: annotate
  `# shellcheck disable=SC2016`.
- Avoid subshell in loops: `while read ...; done < <(find ...)` (process
  substitution), not `find | while`.

## Modern CLIs

When the environment guarantees them (via mise/dotfiles), prefer:

| Instead of | Use |
|---|---|
| `find` | `fd` |
| `grep` | `rg` |
| `sed` | `sd` |
| `cat` (human reading) | `bat` |

JSON/YAML: `jq`/`yq`. HTTP: `xh` or `curl`. In scripts that must run on a
bare machine (installers), stick to POSIX/coreutils.

## Idempotency

Setup/install scripts must converge, not accumulate:

- `mkdir -p`, `ln -sfn`, check before appending
  (`grep -q "line" file || echo "line" >> file`).
- Running twice = same result, with no error or duplicated effect
  (mandatory in `prepare`, playbooks, and installers).

## Security

- Never interpolate untrusted input into `eval`/commands.
- Cleanup with trap: `trap 'rm -rf "$TMP_DIR"' EXIT INT TERM`.
- Temporary files in the repo scratch (`.tmp/`) or `mktemp`, never
  scattered around.
- No hardcoded secrets — read from the environment (skill `env`).

## Structure

- Small functions with descriptive names; `main` at the end when the script grows.
- Clear progress messages (the dotfiles scripts standard:
  `echo "  → item"`).
- Prefer a file-based mise task over a loose script — discovery via
  `mise tasks` (skill `new-task`).
