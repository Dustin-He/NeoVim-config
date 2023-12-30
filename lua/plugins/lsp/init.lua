local nvim_lspconfig = {
    {
        "folke/neodev.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local servers_ok, servers = pcall(require, "plugins.lsp.servers")
            require("neodev").setup({})
            if servers_ok then
                local cap_opts = { capabilities = vim.deepcopy(require('cmp_nvim_lsp').default_capabilities()) }
                for _, server in ipairs(servers.server_names) do
                    local settings_ok, settings = pcall(require, "plugins.lsp.languages." .. server)
                    if settings_ok then
                        settings = vim.tbl_deep_extend("force", cap_opts, settings)
                    else
                        settings = vim.tbl_deep_extend("force", cap_opts, {})
                    end
                    lspconfig[server].setup(settings)
                end
            else
                print("No servers found\n")
            end

            local diagnostic_signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            }
            for _, sign in ipairs(diagnostic_signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end
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

-- if server == 'clangd' then
--     lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
--         if config.name == "clangd" then
--             -- local custom_server_prefix = "/Users/hejintao/.local/share/nvim/mason"
--             local custom_server_prefix = "/opt/homebrew/opt/llvm/"
--             -- local custom_server_prefix = "/usr"
--             config.cmd = { custom_server_prefix .. "/bin/clangd",
--                 "--header-insertion=never",
--                 "--query-driver=/opt/homebrew/opt/llvm/bin/clang",
--                 -- "--query-driver=/usr/bin/clang",
--                 "--all-scopes-completion",
--                 "--completion-style=detailed",
--                 -- "--log=verbose",
--             }
--             -- config.init_options = {
--             --     -- fallbackFlags = {
--             --     --     "-std=c++20",
--             --     -- }
--             -- }
--         end
--     end)
-- end
