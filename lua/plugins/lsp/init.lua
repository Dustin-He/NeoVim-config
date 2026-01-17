local nvim_lspconfig = {
    {
        "folke/neodev.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        cond = (function() return not vim.g.vscode end),
        config = function()
            local servers_ok, servers = pcall(require, "plugins.lsp.servers")
            require("neodev").setup({})
            if servers_ok then
                -- local cap_opts = { capabilities = vim.deepcopy(require('cmp_nvim_lsp').default_capabilities()) }
                local cap_opts = { capabilities = vim.deepcopy(require('blink.cmp').get_lsp_capabilities()) }
                for _, server in ipairs(servers.server_names) do
                    local settings_ok, settings = pcall(require, "plugins.lsp.languages." .. server)
                    if settings_ok then
                        settings = vim.tbl_deep_extend("force", cap_opts, settings)
                    else
                        settings = vim.tbl_deep_extend("force", cap_opts, {})
                    end
                    vim.lsp.config(server, settings)
                    -- vim.lsp.enable(server)
                end
            else
                print("No servers found\n")
            end

            -- Deprecated way of defining diagnostic signs
            local diagnostic_signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "󰌵" },
                { name = "DiagnosticSignInfo", text = "" },
            }
            -- for _, sign in ipairs(diagnostic_signs) do
            --     vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            -- end
            -- vim.diagnostic.config({
            --     signs = {
            --         text = {
            --             [vim.diagnostic.severity.ERROR] = "",
            --             [vim.diagnostic.severity.WARN] = "",
            --             [vim.diagnostic.severity.HINT] = "󰌵",
            --             [vim.diagnostic.severity.INFO] = "",
            --         },
            --         texthl = {
            --             [vim.diagnostic.severity.ERROR] = "Error",
            --             [vim.diagnostic.severity.WARN] = "Warn",
            --             [vim.diagnostic.severity.HINT] = "Hint",
            --             [vim.diagnostic.severity.INFO] = "Info",
            --         },
            --         numhl = {
            --             [vim.diagnostic.severity.ERROR] = "",
            --             [vim.diagnostic.severity.WARN] = "",
            --             [vim.diagnostic.severity.INFO] = "",
            --             [vim.diagnostic.severity.HINT] = "",
            --         },
            --     },
            -- })

            local diagnostic_config = {
                -- disable virtual text
                virtual_text = false,
                -- show signs
                signs = {
                    active = diagnostic_signs,
                },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }
            vim.diagnostic.config(diagnostic_config)

            local keymaps_ok, keymaps = pcall(require, "plugins.lsp.keymaps")
            if not keymaps_ok then
                vim.notify("LSP keymaps not found\n", vim.log.levels.DEBUG)
                return
            end
            keymaps.set_keymaps()
        end
    } }

return nvim_lspconfig
