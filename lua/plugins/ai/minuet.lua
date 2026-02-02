local minuet = {
    {
        'milanglacier/minuet-ai.nvim',
        config = function()
            require('minuet').setup {
                -- Your configuration options here
                provider = 'openai_fim_compatible',
                -- provider = 'openai_compatible',
                n_completions = 1, -- recommend for local model for resource saving
                -- I recommend beginning with a small context window size and incrementally
                -- expanding it, depending on your local computing power. A context window
                -- of 512, serves as an good starting point to estimate your computing
                -- power. Once you have a reliable estimate of your local computing power,
                -- you should adjust the context window to a larger value.
                context_window = 4096,
                request_timeout = 10,
                provider_options = {
                    openai_fim_compatible = {
                        -- openai_compatible = {
                        -- For Windows users, TERM may not be present in environment variables.
                        -- Consider using APPDATA instead.
                        -- model = 'qwen3-coder-plus',
                        model = 'qwen2.5-coder-32b-instruct',
                        -- end_point = 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions',
                        end_point = 'https://dashscope.aliyuncs.com/compatible-mode/v1/completions',
                        api_key = 'DASHSCOPE_API_KEY',
                        name = 'Qwen',
                        stream = false,
                        optional = {
                            max_tokens = 8192,
                            top_p = 0.9,
                            -- stop = {'\n\n'},
                        },
                        template = {
                            prompt = function(context_before_cursor, context_after_cursor, opts)
                                local str = "<|fim_prefix|>" ..
                                    context_before_cursor .. "<|fim_suffix|>" .. context_after_cursor .. "<|fim_middle|>"
                                return str
                            end,
                            -- suffix = function(context_before_cursor, context_after_cursor, opts)
                            --     return
                            --         context_after_cursor
                            -- end,
                        }
                    },
                },
                notfiy = 'debug'
            }
        end,
    },
    { 'nvim-lua/plenary.nvim' },
    -- optional, if you are using virtual-text frontend, nvim-cmp is not required.
    --     -- { 'hrsh7th/nvim-cmp' },
}

return minuet
