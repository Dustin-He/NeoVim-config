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

            local keymaps_ok, keymaps = pcall(require, "plugins.lsp.keymaps")
            if not keymaps_ok then
                vim.notify("LSP keymaps not found\n", vim.log.levels.DEBUG)
                return
            end
            keymaps.set_keymaps()
        end
    } }

return nvim_lspconfig
