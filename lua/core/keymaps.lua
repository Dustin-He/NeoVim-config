-- Leader key
vim.g.mapleader = " "

local keymap = vim.keymap

-- Insert Mode --
-- Escape
keymap.set("i", "jk", "<ESC>")


-- Visual Mode --
-- Move multiple lines
keymap.set("v", "<leader>j", ":m '>+1<CR>gv")
keymap.set("v", "<leader>k", ":m '<-2<CR>gv")
keymap.set("v", "<leader>.", ">gv")
keymap.set("v", "<leader>,", "<gv")
-- Multi-line jump
keymap.set("v", "J", "10j")
keymap.set("v", "K", "10k")
keymap.set("v", "H", "10h")
keymap.set("v", "L", "10l")
keymap.set("v", "W", "5w")
keymap.set("v", "B", "5b")
keymap.set("v", "P", "5p")

-- Normal Mode --
-- Split window
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-l>", "<C-w>l")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
-- Resize window
keymap.set("n", "<S-Up>", ":resize +1<CR>")
keymap.set("n", "<S-Down>", ":resize -1<CR>")
keymap.set("n", "<S-Left>", ":vertical resize +1<CR>")
keymap.set("n", "<S-Right>", ":vertical resize -1<CR>")
-- Change buffer
keymap.set("n", "<leader>n", ":bn<CR>")
keymap.set("n", "<leader>p", ":bp<CR>")
-- Cancel search highlight
keymap.set("n", "<leader>hl", ":nohl<CR>")
-- Multi-line jump
keymap.set("n", "J", "10j")
keymap.set("n", "K", "10k")
keymap.set("n", "H", "10h")
keymap.set("n", "L", "10l")
keymap.set("n", "W", "5w")
keymap.set("n", "B", "5b")
-- Nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
-- Bufferline
keymap.set("n", "<leader><tab>", ":BufDel<CR>")
-- ToggleTerm
keymap.set("n", "<leader>t", ":ToggleTerm direction=float<CR>")




