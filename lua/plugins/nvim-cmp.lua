local nvim_cmp = {
    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            'saadparwaiz1/cmp_luasnip',
            'onsails/lspkind-nvim',
        },
        config = function()
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if not cmp_status_ok then
                return
            end
            local luasnip_status_ok, luasnip = pcall(require, "luasnip")
            if not luasnip_status_ok then
                return
            end

            local kind_symbol = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
                Copilot = "",
            }

            -- lspkind.init({ symbol_map = kind_symbol, })

            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
            -- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
            -- vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

            local local_mapping = {
                -- 上一个
                ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
                -- 下一个
                ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
                -- 出现补全
                ['<M-.>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                -- 取消
                ['<M-,>'] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                -- 确认
                -- Accept currently selected item. If none selected, `select` first item.
                -- Set `select` to `false` to only confirm explicitly selected items.
                ['<CR>'] = cmp.mapping({
                    i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    s = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                }),
                -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
            }

            cmp.setup {
                -- 指定 snippet 引擎
                snippet = {
                    expand = function(args)
                        -- For `luasnip` users.
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                -- 来源
                sources = cmp.config.sources({
                        { name = 'minuet' },
                        { name = 'copilot' },
                        { name = 'nvim_lsp' },
                        { name = 'nvim_lua' },                 -- For luasnip users.
                        { name = 'luasnip' } },
                    { { name = 'buffer' }, { name = 'path' } } -- no cmdline
                ),
                performance = {
                    fetching_timeout = 2000,
                },

                -- 快捷键
                -- mapping = require'keybindings'.cmp(cmp),
                mapping = cmp.mapping.preset.insert(local_mapping),


                -- window = {
                --     documentation = cmp.config.window.bordered(),
                -- },
                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        -- col_offset = -3,
                        side_padding = 0,
                    },
                    -- Transparent documentation
                    documentation = cmp.config.window.bordered()
                },
                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = function(entry, vim_item)
                        local custom_menu_icon = {
                            minuet = "󱚦",
                        }
                        vim_item.kind = string.format('%s %s', kind_symbol[vim_item.kind], vim_item.kind)
                        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry,
                            vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " " .. strings[2]
                        kind.menu = "    [" .. (string.upper(entry.source.name) or "") .. "]"
                        if entry.source.name == "minuet" then
                            kind.kind = " " .. (custom_menu_icon["minuet"] or "") .. " " .. string.upper(strings[2])
                        end

                        return kind
                    end,
                },
                experimental = {
                    ghost_text = false,
                },
            }
            -- Use buffer source for `/`.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.insert(local_mapping),
                sources = {
                    { name = 'buffer' }
                }
            })
            -- Use cmdline & path source for ':'.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.insert(local_mapping),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })

            -- load vscode snippet (friendly-snippet)
            require("luasnip.loaders.from_vscode").lazy_load()
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
        end
    },

    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { 'rafamadriz/friendly-snippets', }
    },
}

return nvim_cmp
