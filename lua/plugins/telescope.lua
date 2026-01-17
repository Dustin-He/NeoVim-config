local telescope = { {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = { { 'nvim-lua/plenary.nvim' }, },
    keys = {"<leader>ff", "<leader>fg", "<leader>fb", "<leader>fh"},
    event = {"User AlphaReady"},
    cond = (function() return not vim.g.vscode end),
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find bufers" })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find help tags" })
        require("telescope").setup{
            defaults = {
                mappings = {
                    n = {
                        ["q"] = require("telescope.actions").close,
                    },
                }
            }
        }
        require("telescope").load_extension("noice")
    end
} }

return telescope
