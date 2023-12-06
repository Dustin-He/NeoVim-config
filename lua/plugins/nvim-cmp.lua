local nvim_cmp = {
    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        lazy = false,
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local lspkind = require('lspkind')
            local cmp = require'cmp'
            local local_mapping  = {
                -- 上一个
                ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
                -- 下一个
                ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
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
                ['<CR>'] = cmp.mapping.confirm({
                  select = true,
                  behavior = cmp.ConfirmBehavior.Replace
                }),
                -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
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
                { name = 'nvim_lsp' },
                -- For luasnip users.
                { name = 'luasnip' }},
                { { name = 'buffer' }, { name = 'path' } }
              ),

              -- 快捷键
              -- mapping = require'keybindings'.cmp(cmp),
              mapping = cmp.mapping.preset.insert(local_mapping),

              -- 使用lspkind-nvim显示类型图标
              formatting = {
                format = lspkind.cmp_format({
                  with_text = true, -- do not show text alongside icons
                  maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                  before = function (entry, vim_item)
                    -- Source 显示提示来源
                    vim_item.menu = "["..string.upper(entry.source.name).."]"
                    return vim_item
                  end
                })
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

            -- Set up lspconfig.
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            -- require('lspconfig')['ltex'].setup {
            --     capabilities = capabilities
            -- }
            require('lspconfig')['texlab'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['clangd'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['lua_ls'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['pylsp'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['marksman'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['cmake'].setup {
                capabilities = capabilities
            }
            require('lspconfig')['golangci_lint_ls'].setup {
                capabilities = capabilities
            }
        end
    },
    
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {'rafamadriz/friendly-snippets',}
    },
    
    {
        'saadparwaiz1/cmp_luasnip'
    },

    -- {
    --     'rafamadriz/friendly-snippets'
    -- },

    {
        'onsails/lspkind-nvim'
    },
}

return nvim_cmp
