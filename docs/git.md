# Git

## How `~/.gitconfig` is assembled

`apply-files` concatenates pieces from this repo into a single
`~/.gitconfig` on every run:

```
~/.gitconfig  =  home/.gitconfig-base
              +  home/.gitconfig-gui     (if a graphical session is detected)
              +  home/.gitconfig-nogui   (otherwise)
              +  [commit]/[tag] gpgsign  (if an SSH agent is reachable)
```

GUI is detected by `$DISPLAY` / `$WAYLAND_DISPLAY` on Linux, and is always
true on macOS. There is no `[includeIf]` magic — the file is rebuilt
deterministically each time you run `apply:files`. This avoids subtle
"include drift" between machines.

### Pieces

| File | Always applied? | Notes |
|------|-----------------|-------|
| [`home/.gitconfig-base`](../home/.gitconfig-base) | Yes | User identity, aliases, color, SSH-key signing, SOPS, SSH-over-HTTPS rewrite |
| [`home/.gitconfig-gui`](../home/.gitconfig-gui) | GUI only | Sublime Merge as `mergetool`, Sublime Text as `editor`, delta with `--side-by-side` |
| [`home/.gitconfig-nogui`](../home/.gitconfig-nogui) | CLI only | Neovim as `editor`, delta in single-pane mode |

Never copy `.gitconfig-gui` / `.gitconfig-nogui` to `~` directly — they're
fragments, not standalone configs (see [AGENTS.md](../AGENTS.md#git-config-files)).

## What's in the base config

### Identity & GitHub

```ini
[user]
  name = Jose Peleteiro
  email = jose@peleteiro.net
[github]
  user = peleteiro
```

### Aliases

```bash
git lg     # decorated, single-line graph log with relative dates
git w      # alias for whatchanged
```

### Colors

Everything color-on (diff, status, branch, interactive, ui, pager). Custom
palette per section in `[color "branch"]`, `[color "diff"]`, `[color "status"]`.

### Commit signing (SSH-based)

```ini
[gpg]
  format = ssh
[user]
  signingkey = key::ssh-ed25519 AAAA...
```

`commit.gpgsign` / `tag.gpgsign` are appended **conditionally** by
`apply-files` only when an SSH agent is reachable — see
[`secrets.md`](./secrets.md#git-commit-signing-ssh-based) for the full story.

### Always SSH for GitHub (never HTTPS)

```ini
[url "git@github.com:"]
  insteadOf = https://github.com/
```

Any `git clone https://github.com/<...>` is silently rewritten to
`git@github.com:<...>`. Avoids accidental token prompts and keeps everything
flowing through the 1Password SSH agent.

### Branches & push

```ini
[branch]
  autosetuprebase = always    # `git pull` rebases by default on new branches
  defaultBranch = main
[init]
  defaultBranch = main
[push]
  default = matching          # push branches with matching names on the remote
```

### Whitespace policy

```ini
[core]
  whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
```

`git apply --whitespace=fix` (and `git diff --check`) flags trailing spaces,
CR-at-EOL, but tolerates indent-with-non-tab (handy in mixed-language repos).

### SOPS integration

```ini
[diff "sops"]
  textconv = sops -d
```

Combined with a `.gitattributes` entry `*.enc.yaml diff=sops`, lets `git diff`
on encrypted files show the plaintext diff.

## GUI vs CLI differences

### `gitconfig-gui` (macOS, Linux with GUI)

- **Editor:** `subl -n -w` (Sublime Text opens a new window, waits)
- **Mergetool:** `smerge` (Sublime Merge), `prompt = false`
- **Diff tool:** `smerge`, `prompt = false`
- **Pager:** `delta` with `--side-by-side --line-numbers`, navigate-on

### `gitconfig-nogui` (Linux without GUI)

- **Editor:** `nvim`
- **Pager:** `delta` with `--line-numbers`, navigate-on (no side-by-side —
  too cramped in single-column terminals)
- No mergetool / difftool — resolve conflicts manually in Neovim

Both rely on [`delta`](https://github.com/dandavison/delta) for diff
rendering. Delta picks colors that match the rest of the Catppuccin Mocha
palette through 256-color ANSI defaults.

## Common tasks

```bash
# Status with the global hooks dir disabled (debug)
git -c core.hooksPath=/dev/null status

# Sign-status of recent commits
git log --show-signature -n 5
# (only verifies your own signatures if you set up gpg.ssh.allowedSignersFile —
#  see secrets.md)

# Pull with rebase (already the default on new branches)
git pull --rebase

# Clone over SSH even when you pasted an HTTPS URL — handled automatically
# by the [url] rewrite in the base config
git clone https://github.com/foo/bar    # → actually clones git@github.com:foo/bar
```

## Working in this repo

The project's own AGENTS.md spells out the conventions for AI agents and
contributors. Key reminders for git:

- **Always create a NEW commit** rather than amending — pre-commit hook
  failures should be fixed with a follow-up commit, not by editing the
  previous one.
- **Don't use `--no-verify`** unless explicitly requested.
- **Don't `git add -A` / `git add .`** — list paths explicitly to avoid
  staging stray secrets.

See [`AGENTS.md`](../AGENTS.md) for the rest.
