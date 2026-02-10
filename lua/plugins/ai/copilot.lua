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
                            listCount = 15,          -- #completions for panel
                            inlineSuggestCount = 10, -- #completions for getCompletions
                        }
                    },
                },
                should_attach = function(_, _)
                    if not vim.bo.buflisted then
                        return false
                    end

                    if vim.bo.buftype ~= "" and vim.bo.buftype ~= "acwrite" then
                        return false
                    end

                    return true
                end,
            })
        end,
    },
    {
        "AndreM222/copilot-lualine"
    }
}

return copilot
