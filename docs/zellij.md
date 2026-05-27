# Zellij

[Zellij](https://zellij.dev) is the terminal multiplexer for this setup
(replacing tmux). It is installed by `./dotfiles apply:install` (via Homebrew
on macOS, via apt on Linux with a GitHub-release fallback when the package
is too old).

## Why Zellij over tmux

- **Discoverable modal UI** — hint bar at the bottom shows the current mode
  and available actions, so you don't have to memorize every binding upfront.
- **Session persistence** — panes, layouts, and scrollback survive a restart
  (`session_serialization`).
- **Layouts as KDL files** — declarative, version-controlled, predictable.
- **No `prefix`-keystroke gymnastics** for every action.

## Files

| Path | Purpose |
|------|---------|
| [`home/.config/zellij/config.kdl`](../home/.config/zellij/config.kdl) | Main configuration: layout, theme, options |
| [`home/.bin/zj`](../home/.bin/zj) | Session wrapper — see [`utilities.md`](./utilities.md#zj--zellij-session-helper) |
| [`home/.bash_completion.d/zj.completion.bash`](../home/.bash_completion.d/zj.completion.bash) | Bash session-name completion |
| [`home/.zsh/completions/_zj`](../home/.zsh/completions/_zj) | Zsh session-name completion |

## `config.kdl` options in use

| Option | Value | Why |
|--------|-------|-----|
| `default_layout` | `"compact"` | Single status line at the bottom, similar to tmux. Less visual noise than the default tab bar. |
| `pane_frames` | `false` | Removes borders around panes → +1 line/column per split. The focused pane is still highlighted. |
| `theme` | `"mocha-black"` | Custom theme defined in the same file. |
| `styled_underlines` | `true` | Enables curly/dotted underlines for terminals that support them. |
| `mouse_mode` | `true` | Click to focus, drag to resize, scroll to scroll. |
| `copy_on_select` | `true` | Selection → system clipboard, no extra keystroke. |
| `scroll_buffer_size` | `10000` | Same as the old tmux `history-limit`. |
| `scrollback_editor` | `"/usr/bin/env nvim"` | `Alt+e` in scroll mode opens the buffer in Neovim. |
| `session_serialization` | `true` | Sessions persist across exits/reboots. |
| `pane_viewport_serialization` | `true` | Scrollback survives serialization too. |
| `show_startup_tips` / `show_release_notes` | `false` | Less noise after first run. |

## The `mocha-black` theme

Defined inline at the bottom of `config.kdl`. It is a Catppuccin Mocha palette
(soft pastels: mint, rose, peach, sky) over a near-black background (`#1a1a1a`)
instead of the original mocha base `#1e1e2e`.

Foreground / 16 ANSI:

| Slot | Hex | Use |
|------|-----|-----|
| `fg` | `#cdd6f4` | text |
| `bg` | `#1a1a1a` | background |
| `black` (bright black) | `#45475a` | neutral gray |
| `red` | `#f38ba8` | rose pastel |
| `green` | `#a6e3a1` | mint |
| `yellow` | `#f9e2af` | cream |
| `blue` | `#89b4fa` | sky |
| `magenta` | `#f5c2e7` | pink |
| `cyan` | `#94e2d5` | teal |
| `white` | `#bac2de` | off-white |
| `orange` | `#fab387` | peach |

To swap themes, replace the `theme "mocha-black"` line with any built-in (see
[Zellij theme list](https://zellij.dev/documentation/theme-list.html)) and
delete the custom theme block if you don't want it loaded.

## Day-to-day usage via `zj`

```bash
zj            # attach to most recent session, or create "default"
zj <name>     # attach/create <name>
zj <Tab>      # list sessions (bash + zsh completion)
```

See [`utilities.md`](./utilities.md#zj--zellij-session-helper) for the full
script reference.

## Keybindings (Zellij default modal system)

You stay in **Normal mode** by default and enter focused submodes for specific
actions. The hint bar at the bottom shows what's available in the current mode.

| From Normal mode | Enters mode | Common actions |
|------------------|-------------|----------------|
| `Ctrl-p` | **Pane** | `n` new, `x` close, `h/j/k/l` focus, `H/J/K/L` resize, `f` fullscreen, `r` rename |
| `Ctrl-t` | **Tab** | `n` new, `x` close, `r` rename, `1..9` jump, `←/→` move |
| `Ctrl-s` | **Scroll** | `↑/↓` line, `PgUp/PgDn` page, `Alt+e` open in `$EDITOR`, `Esc` exit |
| `Ctrl-o` | **Session** | `d` detach, `w` session manager, `c` rename |
| `Ctrl-h` | **Move** | move panes around the workspace |
| `Ctrl-g` | **Lock** | locks all key handling; unlock with `Ctrl-g` again — useful when an app needs the bindings Zellij swallowed |
| `Ctrl-q` | quit current session | — |

From **inside** a submode, press `Esc` to return to Normal.

To learn more without leaving the terminal: `zellij setup --dump-config` prints
the full default config with every binding spelled out.

## Integration with the rest of the setup

- **Editor:** [`scrollback_editor`](#configkdl-options-in-use) opens the
  current pane's history in Neovim via `Alt+e` — see [`nvim.md`](./nvim.md).
- **Prompt:** Starship's Catppuccin Mocha palette matches the Zellij theme;
  the terminal feels visually unified.
- **Shell:** `zellij list-sessions --short` powers the `zj` completion in both
  shells — see [`zsh.md`](./zsh.md#completions).

## Tweaking the config

`./dotfiles apply:files` copies `config.kdl` to `~/.config/zellij/`. Zellij
reloads on save inside a running session, so you can iterate by editing the
file in `home/.config/zellij/` and running `./dotfiles apply:files` from
another pane.
