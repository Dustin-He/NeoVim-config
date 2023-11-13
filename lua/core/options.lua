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

-- Enable wrap
opt.wrap = true
opt.display:append("lastline")

-- Cursor position
opt.scrolloff = 5

-- Cursor line
opt.cursorline = true
local augroup_color = vim.api.nvim_create_augroup("color_cmds", {clear = true})
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = "*",
    group = augroup_color,
    command = [[highlight CursorLine guibg=NONE gui=underline,bold]]
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
opt.spelllang:append("en_US")

-- Language
vim.api.nvim_exec('language time en_US.UTF-8', true)

local augroup_large = vim.api.nvim_create_augroup("large_file_cmds", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufReadPre"}, {
    pattern = "*",
    group = augroup_large,
    callback = function()
        local largeFileSize = 1024 * 1024 * 1024
        local fileSize = vim.fn.getfsize(vim.fn.expand("<afile>"))
        if fileSize < largeFileSize then
            -- Code folding
            opt.foldmethod = "expr"
            opt.foldexpr = "nvim_treesitter#foldexpr()"
            local augroup_folding = vim.api.nvim_create_augroup("code_folding_cmds", {clear = true})
            vim.api.nvim_create_autocmd({"VimEnter", "BufWinEnter", "BufRead", "FileReadPost"}, {
              pattern = "*",
              group = augroup_folding,
              command = "normal zR"
            })
            -- require("lazy").setup("plugins")
        end
    end
})

