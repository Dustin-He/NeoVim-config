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
keymap("n", "J", "10j", opts)
keymap("n", "K", "10k", opts)
keymap("n", "H", "10h", opts)
keymap("n", "L", "10l", opts)
keymap("n", "W", "5w", opts)
keymap("n", "B", "5b", opts)
-- Nvim-tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
-- Bufferline
keymap("n", "<leader><tab>", ":BufDel<CR>", opts)
-- ToggleTerm
keymap("n", "<leader>t", ":ToggleTerm direction=float<CR>", opts)




