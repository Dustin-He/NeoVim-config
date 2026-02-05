local lazygit = {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cond = (function() return not vim.g.vscode end),
    init = function()
        vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "<leader>g", ":LazyGit<CR>", opts)
    end
}

return lazygit
