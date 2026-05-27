# Zsh

Zsh is the default login shell. `./dotfiles apply:install` installs it
(`brew install zsh` on macOS, `apt install zsh` on Linux), registers it in
`/etc/shells`, and runs `chsh -s` to set it as the login shell automatically
(it may prompt for your password).

Bash is still fully supported as a secondary shell — the project keeps shared
configuration that loads cleanly in both.

## File layout

| Path | Purpose |
|------|---------|
| [`home/.zshrc`](../home/.zshrc) | Interactive shell config (options, history, completions, plugins) |
| [`home/.zprofile`](../home/.zprofile) | Login-shell config; sources `.zshrc` if interactive |
| [`home/.zsh_functions`](../home/.zsh_functions) | Reusable shell functions (`proj`, `java_use`) |
| [`home/.zsh/aliases.zsh`](../home/.zsh/aliases.zsh) | Personal zsh-only aliases (`l`, `ll`) |
| [`home/.zsh/completions/`](../home/.zsh/completions) | Custom completion files (autoloaded via `fpath`) |
| [`home/.shared_shell_config`](../home/.shared_shell_config) | Shared between bash and zsh (PATH, env vars, generic aliases) |

The shared file is sourced first; zsh-only files override or extend on top.

## Prompt

[Starship](https://starship.rs) with a Catppuccin Mocha pastel palette
(see [`home/.config/starship.toml`](../home/.config/starship.toml)):

- **Directory** in mint green (`#a6e3a1`)
- **Git branch** in sky blue (`#89b4fa`)
- **Prompt `$`** in soft lavender (`#cdd6f4`) on success, rose (`#f38ba8`) on
  non-zero exit code

The palette is the same one used by the Zellij theme — so editor, multiplexer,
and prompt all match.

## Plugins

Two zsh plugins are installed via the OS package manager and sourced
automatically at the bottom of `.zshrc`:

- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** —
  Fish-style inline suggestions in dim text as you type. Accept with `→` or
  `End`. Strategy is `(history completion)`.
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** —
  Colors commands while typing. Green = valid command, red = not found. Catches
  typos before Enter. Must be sourced last; the config takes care of that.

Plugin paths are detected by OS:

- macOS: `$HOMEBREW_PREFIX/share/zsh-{autosuggestions,syntax-highlighting}/`
- Linux: `/usr/share/zsh-{autosuggestions,syntax-highlighting}/`

## Directory stack

`auto_pushd` is enabled, so every `cd` pushes the previous directory onto a
stack:

```zsh
d           # show numbered stack (alias for `dirs -v | head -20`)
cd -2       # jump to entry 2
cd -        # toggle with previous directory
```

Also active: `pushd_ignore_dups` (no duplicates) and `pushd_silent` (no echo).

## Key bindings (emacs mode)

| Keys | Action |
|------|--------|
| `Ctrl-R` | Incremental backward history search |
| `Ctrl-S` | Incremental forward history search |
| `Ctrl-X Ctrl-E` | Edit current command line in `$EDITOR` (Neovim) |
| `→` / `End` | Accept autosuggestion |

## History

- `HISTFILE=~/.zsh_history`, `HISTSIZE=1000`, `SAVEHIST=2000`
- `share_history` — history is live-shared across open sessions
- `hist_ignore_dups` — consecutive duplicates are dropped
- `hist_ignore_space` — commands prefixed with a space are not recorded
- `inc_append_history` — entries are written immediately, not on shell exit

## Completions

The `home/.zsh/completions/` directory is prepended to `$fpath` before
`compinit` runs. To add a completion for a command `foo`, drop a `_foo` file
there with the `#compdef foo` directive on the first line.

Existing example: [`_zj`](../home/.zsh/completions/_zj) completes Zellij session
names via `zellij list-sessions --short`.

### Bash completion compatibility

`.zshrc` loads `bashcompinit`, so bash completions using `complete -F` or
`complete -C` work in zsh without duplication. This covers most third-party
CLIs (Docker, AWS, pipenv, etc.). Reach for a native zsh `_foo` only when you
need something the bash function doesn't provide.

## Other behavior

- `autocd` — typing a directory name `cd`s into it.
- `extended_glob` — patterns like `^foo`, `(a|b)`, `**/*.lua` work.
- `no_beep` — silence the terminal bell.
- Completion menu is selectable; matchers are case-insensitive.

## Adding your own private config

Drop a `~/.zshrc_private` file (not tracked by the repo). It is sourced at the
end of `.zshrc`, ideal for machine-specific aliases, work secrets exports, or
experiments.
