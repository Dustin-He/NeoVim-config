local lazygit = {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    init = function()
        vim.g.lazygit_floating_window_winblend = 1 -- transparency of floating window
        vim.g.lazygit_floating_window_scaling_factor = 0.9
    end
}

return lazygit
