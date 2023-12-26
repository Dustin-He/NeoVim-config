-- Define a local variable
local opt = vim.opt

-- Dagerous no backup file
opt.backup = false
opt.writebackup = false
opt.swapfile = true

-- File encoding
opt.fileencoding = "UTF-8"

-- Something about cmp pop up menu and the cmd
opt.cmdheight = 2
opt.pumheight = 10
opt.completeopt = {"menuone", "noselect"}

-- Show
opt.conceallevel = 0

-- Undo history
opt.undofile = false

-- Auto save
opt.autowriteall = false

-- Line number
opt.number = true
opt.relativenumber = true

-- Tab options
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Enable wrap
opt.wrap = true
opt.display:append("lastline")

-- Cursor position
opt.scrolloff = 5
opt.sidescrolloff = 5

-- Cursor line
opt.cursorline = true
local augroup_color = vim.api.nvim_create_augroup("color_cmds", {clear = true})
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = "*",
    group = augroup_color,
    command = [[highlight CursorLine gui=bold]],
    -- command = [[highlight CursorLine guibg=NONE gui=bold,underline]],
    nested = true,
})

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
opt.showcmd = true
opt.showcmdloc = 'statusline'

-- Spell Check
opt.spell = true
-- opt.spelllang:append("en_US")

-- Hide the annoying complete messages
opt.shortmess:append "c"

-- Move the cursor to next/previous line
vim.cmd "set whichwrap+=<,>,[,],h,l"

-- "-" is part of a word
vim.cmd [[set iskeyword+=-]]

-- Doesn't work in lua, but works in cmd
-- vim.cmd [[set formatoptions-=cro]]

-- Language
vim.api.nvim_exec('language time en_US.UTF-8', true)

vim.g.python3_host_prog = "/usr/bin/python3"

