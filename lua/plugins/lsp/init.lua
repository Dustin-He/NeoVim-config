local nvim_lspconfig = {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            'williamboman/mason-lspconfig.nvim',
            "saghen/blink.cmp",
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            }
        },
        lazy = false,
        cond = (function() return not vim.g.vscode end),
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })

            local installed_servers = {
                "clangd",
                "cmake",
                "gopls",
                "texlab",
                "html",
                "jsonls",
                "ts_ls",
                "lua_ls",
                "marksman",
                "pyright",
                "ruff",
                "rust_analyzer",
                "lemminx",
                "yamlls",
                "jdtls",
                "jsonls",
                "vimls",
                "bashls",
            }

            require("mason-lspconfig").setup({
                ensure_installed = installed_servers,
            })

            -- 2. 配置 Handlers (自动化逻辑)
            local function handler(server_name)
                local opts = {}

                local module_name = "plugins.lsp.languages." .. server_name
                local status, custom_opts = pcall(require, module_name)

                if status then
                    opts = custom_opts
                end

                -- 合并 capabilities
                opts.capabilities = require('blink.cmp').get_lsp_capabilities(opts.capabilities)

                -- 启动 Server
                vim.lsp.config(server_name, opts)
                -- Do not need this since mason-lspconfig enables all servers
                -- vim.lsp.enable(server_name)
            end

            for _, server_name in ipairs(installed_servers) do
                handler(server_name)
            end

            vim.diagnostic.config({
                signs = {
                    active = true,
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                        [vim.diagnostic.severity.HINT]  = "󰌵",
                        [vim.diagnostic.severity.INFO]  = "",
                    },
                },
                virtual_text = false,
                update_in_insert = true,
                underline = false,
                severity_sort = true,
                float = {
                    focusable = false,
                    border = "rounded",
                },
            })

            require('plugins.lsp.keymaps').set_keymaps()
        end
    } }

return nvim_lspconfig
