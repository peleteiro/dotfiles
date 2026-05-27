# Utilities

This document covers the custom scripts shipped in `home/.bin/` and the
notable CLI tools installed by `./dotfiles apply:install`.

## Custom scripts (`~/.bin/`)

All scripts in `home/.bin/` are copied to `~/.bin/` (which is added to `$PATH`
by [`.shared_shell_config`](../home/.shared_shell_config)) and made executable
automatically.

### `zj` — Zellij session helper

```bash
zj              # attach to the most recently used session;
                # if none exist, create one named "default"
zj <name>       # attach to <name>, creating it if it does not exist
zj <Tab>        # list existing sessions (bash and zsh completion)
```

Backed by `zellij attach --create`. See also: the matching completion files in
[`home/.bash_completion.d/zj.completion.bash`](../home/.bash_completion.d/zj.completion.bash)
and [`home/.zsh/completions/_zj`](../home/.zsh/completions/_zj).

### `myip` — Public IP address

```bash
myip            # prints your public IP (via whatismyip.akamai.com)
```

### `ips` — Local IP addresses

```bash
ips             # extracts all `inet ` addresses from `ifconfig`
```

### `down4me` — Is a site down for everyone?

```bash
down4me example.com
                # checks downforeveryoneorjustme.com and reports
                # whether the outage is "just you" or actually down
```

### `my-key` — Read SSH key from 1Password

```bash
my-key public        # SSH public key (from 1Password item)
my-key private       # SSH private key (from 1Password item)
```

Requires the 1Password CLI (`op`) to be authenticated. Reads `OP_SSH_KEY_ID`
from the environment (set in [`.shared_shell_config-{linux,macos}`](../home/)).
If `op` returns no `public key` field, the public key is derived from the
private key via `ssh-keygen -y`.

Also used by `apply-files` to write the public key to `~/.ssh/id_signing.pub`
for git commit/tag signing — see [`git.md`](./git.md).

## Installed CLI tools

### File and text

| Tool | Replaces | Notes |
|------|----------|-------|
| **bat** | `cat` | Syntax-highlighted file viewing. Use directly — not aliased over `cat`. |
| **ripgrep** (`rg`) | `grep -r` | Faster, respects `.gitignore` by default. |
| **fd** | `find` | Friendlier syntax. On Debian/Ubuntu the binary is `fdfind`. |
| **eza** / **exa** | `ls` | Modern `ls`. Aliased as `l` (`-la --git`) and `ll` (`-l --git`) in zsh. |
| **delta** | `diff` / `git diff` | Beautiful unified diff. Wired into git as the pager via `.gitconfig-*`. |
| **sd** | `sed` | Modern regex replacement with intuitive syntax. |
| **ouch** | `tar` / `unzip` | Universal `(de)compress` for any archive format. |

### System monitoring

| Tool | Replaces | Notes |
|------|----------|-------|
| **dust** | `du` | Interactive disk-usage with bars. |
| **procs** | `ps` | Colored, tree-aware process listing. |
| **bottom** (`btm`) | `top` / `htop` | Cross-platform system monitor with graphs. |
| **htop** | `top` | Classic interactive process viewer (Linux only here). |
| **tree** | — | Directory tree visualization. |

### Git and dev

| Tool | Notes |
|------|-------|
| **gitui** | Full-screen terminal UI for git (faster than `tig`/`lazygit` for big repos). |
| **hyperfine** | Statistically rigorous command benchmarking. |
| **tealdeer** (`tldr`) | Practical examples for any command. Run `tldr --update` once on a new machine. |
| **gh** | Official GitHub CLI. |
| **hub** | Git wrapper with GitHub helpers (legacy companion to `gh`). |

### Multiplexer, prompt, editor

| Tool | Notes |
|------|-------|
| **zellij** | Terminal multiplexer. Used via the [`zj`](#zj--zellij-session-helper) wrapper. Config in [`home/.config/zellij/config.kdl`](../home/.config/zellij/config.kdl). |
| **starship** | Cross-shell prompt. Catppuccin Mocha colors in [`starship.toml`](../home/.config/starship.toml). |
| **neovim** | Official terminal editor. See [`nvim.md`](./nvim.md). |

### Other notable installs

- **1Password CLI** (`op`) — backbone of SSH key management and git signing;
  see [`my-key`](#my-key--read-ssh-key-from-1password) and [`secrets.md`](./secrets.md).
- **mise** — runtime version manager. Project tools declared in
  [`mise.toml`](../mise.toml). Activated via
  `eval "$(mise activate <shell>)"` in [`shared_shell_config`](../home/.shared_shell_config).
- **aria2** — multi-connection download tool.
- **jq**, **sqlite3**, **exiftool**, **jpegoptim**, **pngcrush**, **imagemagick** — file-format utilities used ad hoc.

## Adding a new utility

1. Drop a script into `home/.bin/`. Make sure the shebang is `#!/bin/bash` (or
   `#!/bin/sh` if it must be POSIX) and pass `mise run lint` (shellcheck).
2. `apply-files` will copy it to `~/.bin/` and `chmod +x` it on the next run.
3. If the script needs completion, add `_name` to
   [`home/.zsh/completions/`](../home/.zsh/completions) and/or
   `name.completion.bash` to [`home/.bash_completion.d/`](../home/.bash_completion.d).
4. Document the new script in this file.
