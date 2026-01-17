local claude = {
    "greggh/claude-code.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
        require("claude-code").setup({
            window = {
                position = "vertical", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
                split_ratio = 0.4,     -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
                enter_insert = true,   -- Whether to enter insert mode when opening Claude Code
                hide_numbers = true,   -- Hide line numbers in the terminal window
                hide_signcolumn = true, -- Hide the sign column in the terminal window

                float = {
                    width = "90%",     -- Take up 90% of the editor width
                    height = "90%",    -- Take up 90% of the editor height
                    row = "center",    -- Center vertically
                    col = "center",    -- Center horizontally
                    relative = "editor",
                    border = "double", -- Use double border style
                },
            },
        })
    end
}

return claude
