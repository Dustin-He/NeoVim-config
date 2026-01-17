local blink = {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
        { 'rafamadriz/friendly-snippets' },
        { "fang2hou/blink-copilot" },
        { 'L3MON4D3/LuaSnip',            version = 'v2.*' },
        { 'milanglacier/minuet-ai.nvim' }
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@diagnostic disable-next-line
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            -- set to 'none' to disable the 'default' preset
            preset = 'super-tab',
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-j>'] = { 'select_next', 'fallback' },
            ['<C-k>'] = { 'select_prev', 'fallback' },
            ['<C-u>'] = {function(cmp) return cmp.select_prev({ count = 5 }) end},
            ['<C-d>'] = {function(cmp) return cmp.select_next({ count = 5 }) end},
            -- disable a keymap from the preset
            ['<M-,>'] = { 'hide' }, -- or {}
            -- show with a list of providers
            ['<M-.>'] = { 'show' },
            ['<C-p>'] = { function(cmp) cmp.scroll_documentation_up(4) end },
            ['<C-n>'] = { function(cmp) cmp.scroll_documentation_down(4) end },
            ['<C-space>'] = { 'hide_documentation' },
            ['<C-e>'] = { 'show_documentation' }
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = {
                auto_show = true,
                window = {
                    border = 'rounded',
                },
            },
            ghost_text = {
                enabled = true,
                -- Show the ghost text when an item has been selected
                show_with_selection = true,
                -- Show the ghost text when no item has been selected, defaulting to the first item
                show_without_selection = false,
                -- Show the ghost text when the menu is open
                show_with_menu = true,
                -- Show the ghost text when the menu is closed
                show_without_menu = true,
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false
                }
            },
            menu = {
                border = 'rounded',
                draw = {
                    columns = { { "label", "label_description", gap = 2 }, { "kind_icon", gap = 1, "kind" } },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                if ctx.kind == 'Copilot' then
                                    kind_icon = ""
                                end
                                if ctx.kind == 'Qwen' then
                                    kind_icon = "󱚦"
                                end
                                return kind_icon
                            end,
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                if ctx.kind == 'Copilot' then
                                    hl = 'CmpItemKindCopilot'
                                end
                                if ctx.kind == 'Qwen' then
                                    hl = 'MiniIconsGreen'
                                end
                                return hl
                            end,
                        },
                        kind = {
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                if ctx.kind == 'Copilot' then
                                    hl = 'CmpItemKindCopilot'
                                end
                                if ctx.kind == 'Qwen' then
                                    hl = 'MiniIconsGreen'
                                end
                                return hl
                            end,
                        }
                    }
                },
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'cmdline', 'minuet' },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                    opts = {
                        max_completions = 5,
                        max_attempts = 5,
                        -- kind_icon = " ",
                        -- kind_name = "Copilot"
                    }
                },
                minuet = {
                    name = 'minuet',
                    module = 'minuet.blink',
                    async = true,
                    -- Should match minuet.config.request_timeout * 1000,
                    -- since minuet.config.request_timeout is in seconds
                    timeout_ms = 3000,
                    score_offset = 50, -- Gives minuet higher priority among suggestions
                },
                buffer = {
                    opts = {
                        -- or (recommended) filter to only "normal" buffers
                        get_bufnrs = function()
                            return vim.tbl_filter(function(bufnr)
                                return vim.bo[bufnr].buftype == ''
                            end, vim.api.nvim_list_bufs())
                        end
                    }
                },
                path = {
                    opts = {
                        get_cwd = function(_)
                            return vim.fn.getcwd()
                        end,
                    },
                },
                snippets = {
                    -- For `snippets.preset == 'luasnip'`
                    opts = {
                        -- Whether to use show_condition for filtering snippets
                        use_show_condition = true,
                        -- Whether to show autosnippets in the completion list
                        show_autosnippets = true,
                        -- Whether to prefer docTrig placeholders over trig when expanding regTrig snippets
                        prefer_doc_trig = false,
                        -- Whether to put the snippet description in the label description
                        use_label_description = false,
                    }
                },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

        cmdline = {
            enabled = true,
            -- use 'inherit' to inherit mappings from top level `keymap` config
            keymap = {
                preset = 'inherit',
            },
            -- sources = { 'buffer', 'cmdline' },

            -- OR explicitly configure per cmd type
            -- This ends up being equivalent to above since the sources disable themselves automatically
            -- when not available. You may override their `enabled` functions via
            -- `sources.providers.cmdline.override.enabled = function() return your_logic end`
            sources = function()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == '/' or type == '?' then return { 'buffer' } end
                -- Commands
                if type == ':' or type == '@' then return { 'cmdline', 'buffer' } end
                return {}
            end,

            completion = {
                trigger = {
                    show_on_blocked_trigger_characters = {},
                    show_on_x_blocked_trigger_characters = {},
                },
                list = {
                    selection = {
                        -- When `true`, will automatically select the first item in the completion list
                        preselect = false,
                        -- When `true`, inserts the completion item automatically when selecting it
                        auto_insert = false,
                    },
                },
                -- Whether to automatically show the window when new completion items are available
                -- Default is false for cmdline, true for cmdwin (command-line window)
                -- menu = { auto_show = function(ctx, _) return ctx.mode == 'cmdwin' end },
                menu = { auto_show = true },
                -- Displays a preview of the selected item on the current line
                ghost_text = { enabled = true },
            }
        }
    },
    opts_extend = { "sources.default" }
}

return blink
