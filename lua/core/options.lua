-- Define a local variable
local opt = vim.opt

-- Line number
opt.number = true
opt.relativenumber = true

-- Tab options
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Disable wrap???
opt.wrap = false

-- Cursor line
opt.cursorline = true

-- Enable the mouse
opt.mouse:append("a")

-- System clip board
opt.clipboard:append("unnamedplus")

-- New a split window on the right/below of the window
opt.splitright = true
opt.splitbelow = true

-- Ignore the letter case when searching, but do not when capital letters exist in the pattern
opt.ignorecase = true
opt.smartcase = true

-- Screen
opt.termguicolors = true
opt.signcolumn = "yes"

-- Bufferline
opt.showmode = false

-- Spell Check
opt.spell = true
opt.spelllang = "en_US"

-- Language
vim.api.nvim_exec('language en_US', true)

-- Code folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

local augroup_folding = vim.api.nvim_create_augroup("code_folding_cmds", {clear = true})
vim.api.nvim_create_autocmd({"VimEnter", "BufWinEnter", "BufRead", "FileReadPost"}, {
  pattern = "*",
  group = augroup_folding,
  command = "normal zR"
})
