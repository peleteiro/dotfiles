# Neovim

Neovim is the official terminal editor for this setup. It is installed on both
macOS (`brew install neovim`) and Linux (`apt install neovim`), and exposed via
`$EDITOR` and `$VISUAL` in [`home/.shared_shell_config`](../home/.shared_shell_config).

## Philosophy

Single-file, zero-plugin `init.lua`. The goal is a snappy editor with sensible
defaults that works the same everywhere with no external dependencies beyond
Neovim itself. If you outgrow it, add `lazy.nvim` and split the config into
modules — but start minimal.

## Location

```
home/.config/nvim/init.lua    →   ~/.config/nvim/init.lua
```

Copied by `./dotfiles apply:files`.

## Leader key

`<Space>` is both `<leader>` and `<localleader>`.

## Keymaps

| Mode | Keys | Action |
|------|------|--------|
| Normal | `<leader>w` | Save current buffer |
| Normal | `<leader>q` | Quit window |
| Normal | `<Esc>` | Clear search highlight |
| Normal | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move between windows |
| Normal | `<C-d>` / `<C-u>` | Half-page scroll, keep cursor centered |
| Visual | `J` / `K` | Move selected lines down / up |
| Visual | `<` / `>` | Indent, keep selection |

Builtin commands you'll use a lot: `:e <file>`, `:w`, `:bd` (close buffer),
`:vsplit`, `:split`, `:term` (terminal in a split).

## Options enabled

- **Numbers:** absolute + relative line numbers (jump with `5j`, `10k`).
- **Cursor:** `cursorline` on, `scrolloff=8` (cursor stays away from edges).
- **Mouse / clipboard:** full mouse support, system clipboard via `unnamedplus`
  (yank in Vim → paste anywhere).
- **Indent:** 2 spaces, smart indent, breakindent. Project `.editorconfig`
  overrides per file type (Neovim has built-in EditorConfig support since 0.9).
- **Search:** case-insensitive unless query has uppercase (`smartcase`),
  incremental, highlighted.
- **Splits:** new splits open below / to the right.
- **Persistence:** `undofile` on (undo survives across sessions); no swap, no
  backup files.
- **Colorscheme:** `habamax` (built-in dark theme; renders well over the
  Catppuccin Mocha palette set in Zellij).

## Autocmds

- **Highlight on yank** — briefly flashes yanked text using `vim.highlight.on_yank`.
- **Trim trailing whitespace on save** — runs `%s/\s\+$//e` with `keeppatterns`.
  Markdown files keep trailing whitespace because of `.editorconfig`.

## Integration with the rest of the setup

- **Editor variable:** `$EDITOR=nvim` and `$VISUAL=nvim` (set in
  [`.shared_shell_config`](../home/.shared_shell_config)).
- **Git commit messages:** opens in Neovim by default for CLI environments
  (configured in `.gitconfig-nogui`).
- **Zellij scrollback:** press `Alt+e` in Zellij's scroll mode to open the
  current pane's scrollback in Neovim (configured in
  [`config.kdl`](../home/.config/zellij/config.kdl) as `scrollback_editor`).
- **Shell editor binding:** in zsh, `Ctrl-X Ctrl-E` opens the current command
  line in Neovim (see [`zsh.md`](./zsh.md)).

## Extending later

If you want plugins, the natural next step is:

1. Bootstrap [`lazy.nvim`](https://github.com/folke/lazy.nvim) at the top of
   `init.lua`.
2. Move keymaps and options into `lua/keymaps.lua` / `lua/options.lua`.
3. Add plugins one at a time under `lua/plugins/`. Suggested starters that pair
   well with this setup:
   - [`catppuccin/nvim`](https://github.com/catppuccin/nvim) — matches the
     Zellij/shell theme.
   - [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)
     — fuzzy finder (now that `fzf` is no longer installed system-wide).
   - [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
     — better syntax highlighting and text objects.
   - [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) —
     language servers.

If you go this route, replace the `init.lua` in this repository with the new
modular structure rather than carrying both.
