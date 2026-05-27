-- Neovim minimal configuration
-- Single-file, zero-plugin init.lua — sensible defaults for terminal use
-- Project conventions come from .editorconfig (built-in support since nvim 0.9)

-- ===== Leader =====
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===== UI =====
vim.opt.number = true              -- absolute line numbers
vim.opt.relativenumber = true      -- relative numbers (jump with 5j, 10k)
vim.opt.cursorline = true          -- highlight current line
vim.opt.signcolumn = "yes"         -- always show sign column (avoids text shift)
vim.opt.showmode = false           -- mode shown by ruler/statusline already
vim.opt.scrolloff = 8              -- keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true       -- 24-bit color (works in Zellij)
vim.opt.fillchars = { eob = " " }  -- hide ~ on empty lines

-- ===== Mouse & clipboard =====
vim.opt.mouse = "a"                -- mouse in all modes
vim.opt.clipboard = "unnamedplus"  -- yank/paste via system clipboard

-- ===== Editing =====
-- Defaults align with .editorconfig (space, 2). EditorConfig overrides per-project.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.breakindent = true

-- ===== Search =====
vim.opt.ignorecase = true
vim.opt.smartcase = true           -- case-sensitive only when query has uppercase
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- ===== Splits =====
vim.opt.splitright = true
vim.opt.splitbelow = true

-- ===== Files & history =====
vim.opt.undofile = true            -- persistent undo across sessions
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- ===== Colorscheme =====
-- habamax: pleasant dark builtin theme; works under Zellij's Catppuccin Mocha palette
vim.cmd.colorscheme("habamax")

-- ===== Keymaps =====
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
map("n", "<Esc>",     "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation (Ctrl-h/j/k/l)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Keep cursor centered when half-page scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Move selected lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep selection after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- ===== Autocmds =====

-- Briefly highlight yanked text (builtin, no plugin needed)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- Trim trailing whitespace on save (matches .editorconfig for most file types)
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Trim trailing whitespace on save",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})
