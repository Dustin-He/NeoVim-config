local codecompanion = {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
    },
    opts = {
        interactions = {
            chat = {
                -- adapter = "copilot",
                -- model = "claude-sonnet-4.5",
                adapter = "qwen",
            },
            inline = {
                adapter = "qwen",
            }
        },
        adapters = {
            http = {
                qwen = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            url = "https://dashscope.aliyuncs.com/compatible-mode",
                            api_key = vim.env.DASHSCOPE_API_KEY,
                            chat_url = "/v1/chat/completions",
                        },
                        schema = {
                            model = {
                                default = "qwen3-coder-plus",
                            },
                            max_tokens = {
                                default = 128000,
                            },
                        },
                    })
                end,
            },
        },
        -- NOTE: The log_level is in `opts.opts`
        opts = {
            log_level = "DEBUG",
        },
        display = {
            chat = {
                window = {
                    width = 0.43, ---@return number|fun(): number
                    -- height = 0.8, ---@return number|fun(): number
                    border = "single",
                }
            },
            action_palette = {
                provider = 'snacks',
                opts = {
                    show_prompt_library_builtins = true,
                }
            }
        },
    },
}

return codecompanion
