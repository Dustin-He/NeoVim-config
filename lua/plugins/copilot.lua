local copilot = {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,
                },
                panel = {
                    enabled = false,
                    auto_refresh = true
                },
                server_opts_overrides = {
                    trace = "verbose",
                    settings = {
                        advanced = {
                            listCount = 15, -- #completions for panel
                            inlineSuggestCount = 10, -- #completions for getCompletions
                        }
                    },
                },
            })
        end,
    },
    -- {
        -- {
        --     "zbirenbaum/copilot-cmp",
        --     config = function()
        --         require("copilot_cmp").setup()
        --     end,
        -- },
    -- },
    {
        "AndreM222/copilot-lualine"
    }
}

return copilot
