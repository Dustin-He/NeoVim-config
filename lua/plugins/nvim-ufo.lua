local ufo = {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
        -- Optional: for a better fold column UI, see documentation for configuration
        "luukvbaal/statuscol.nvim",
    },
    event = "BufReadPost",
    opts = {
        provider_selector = function()
            -- Prioritize treesitter folding, with indent folding as a fallback
            return { "treesitter", "indent" }
        end,
    },
    init = function()
        -- Global keymaps for convenience
        vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
        vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
        -- Standard vim keymaps like `zc` (close current fold) and `zo` (open current fold) should work by default.
    end,

}

return ufo
