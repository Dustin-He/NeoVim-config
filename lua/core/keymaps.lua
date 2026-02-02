-- Leader key
vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

-- Insert Mode --
-- Escape
keymap("i", "jk", "<ESC>", opts)

-- Visual Mode --
-- Move multiple lines
keymap("v", "<leader>j", ":m '>+1<CR>gv", opts)
keymap("v", "<leader>k", ":m '<-2<CR>gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)
-- Multi-line jump
keymap("v", "J", "10j", opts)
keymap("v", "K", "10k", opts)
keymap("v", "H", "10h", opts)
keymap("v", "L", "10l", opts)
keymap("v", "W", "5w", opts)
keymap("v", "B", "5b", opts)
keymap("v", "P", "5p", opts)
-- Paste in visual mode
keymap("v", "p", '"_dP', opts)

-- Normal Mode --
-- Split window
keymap("n", "<leader>sv", "<C-w>v", opts)
keymap("n", "<leader>sh", "<C-w>s", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
-- Resize window
keymap("n", "<S-Up>", ":resize +1<CR>", opts)
keymap("n", "<S-Down>", ":resize -1<CR>", opts)
keymap("n", "<S-Left>", ":vertical resize +1<CR>", opts)
keymap("n", "<S-Right>", ":vertical resize -1<CR>", opts)
-- Change buffer
keymap("n", "<leader>n", ":bn<CR>", opts)
keymap("n", "<leader>p", ":bp<CR>", opts)
-- Cancel search highlight
keymap("n", "<leader>hl", ":nohl<CR>", opts)
-- Multi-line jump
vim.cmd [[nnoremap <silent><expr> j (v:count > 0 ? "m'" . v:count : "") . 'j']]
vim.cmd [[nnoremap <silent><expr> k (v:count > 0 ? "m'" . v:count : "") . 'k']]
keymap("n", "J", "10j", { noremap = false, silent = true })
keymap("n", "K", "10k", { noremap = false, silent = true })
keymap("n", "H", "10h", opts)
keymap("n", "L", "10l", opts)
keymap("n", "W", "5w", opts)
keymap("n", "B", "5b", opts)

-- Open URL
local function open_external(file)
    local sysname = vim.uv.os_uname().sysname:lower()
    local jobcmd
    if sysname:match("windows") then
        -- Not sure if this is correct. I just copied it from the other answers.
        jobcmd = ("start %s"):format(file)
    else
        jobcmd = { "open", "-u", file }
    end
    local job = vim.fn.jobstart(jobcmd, {
        -- Don't kill the started process when nvim exits.
        detach = true,
        -- Make relative paths relative to the current file.
        cwd = vim.fn.expand("%:p:h"),
    })
    -- Kill the job after 5 seconds.
    local delay = 5000
    vim.defer_fn(function()
        vim.fn.jobstop(job)
    end, delay)
end
vim.keymap.set("n", "gx", function()
    open_external(vim.fn.expand("<cfile>"))
end)
