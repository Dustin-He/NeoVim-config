local nvim_lspconfig = { {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
        require("lspconfig").lua_ls.setup {}
        require("lspconfig").ltex.setup {}
        require("lspconfig").marksman.setup {}
        require("lspconfig").golangci_lint_ls.setup {}
        require("lspconfig").lemminx.setup {}
        require("lspconfig").rust_analyzer.setup {}
        require("lspconfig").pylsp.setup {}

        require("lspconfig").clangd.setup {
        }
        local lspconfig = require 'lspconfig'
        lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
          if config.name == "clangd" then
            local custom_server_prefix = "/Users/hejintao/.local/share/nvim/mason"
            -- local custom_server_prefix = "/usr"
            config.cmd = { custom_server_prefix .. "/bin/clangd",
                "--header-insertion=never",
                "--query-driver=/usr/bin/clang",
                "--all-scopes-completion",
                "--completion-style=detailed",
                -- "--log=verbose",
            }
            -- config.init_options = {
            --     -- fallbackFlags = {
            --     --     "-std=c++20",
            --     -- }
            -- }
          end
        end)
        -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<space>w', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
        -- vim.keymap.set('n', '<space>h', vim.diagnostic.hide)
        -- vim.keymap.set('n', '<space>s', vim.diagnostic.show)
        vim.diagnostic.config({vim.diagnostic.disable()})

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gk', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)
            end,
        })
    end
} }

return nvim_lspconfig
