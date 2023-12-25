local M = {}

M.set_keymaps = function()
    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, {desc = "Diagnostic.open float"})
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = "Diagnostic.go to prev"})
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = "Diagnostic.go to next"})
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {desc = "Diagnostic.setloclist"})
    -- vim.keymap.set('n', '<space>h', vim.diagnostic.hide)
    -- vim.keymap.set('n', '<space>s', vim.diagnostic.show)
    -- vim.diagnostic.config({ vim.diagnostic.disable() })

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer = ev.buf, desc = "Go to Declaration"})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = ev.buf, desc = "Go to defenition"})
            vim.keymap.set('n', 'gh', vim.lsp.buf.hover, {buffer = ev.buf, desc = "Hover enable"})
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer = ev.buf, desc = "Implementation"})
            -- vim.keymap.set("n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', {buffer = ev.buf, desc = "Open float"})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {buffer = ev.buf, desc = "Go to references"})
            -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {buffer = ev.buf, desc = "Signature_help"})
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, {buffer = ev.buf, desc = "Add workspace folder"})
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, {buffer = ev.buf, desc = "Remove workspace folder"})
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, {buffer = ev.buf, desc = "List workspace folders"})
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, {buffer = ev.buf, desc = "Go to type defenition"})
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {buffer = ev.buf, desc = "Rename variables"})
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, {buffer = ev.buf, desc = "Code actions"})
            vim.keymap.set('n', '<space>f', function()
                vim.lsp.buf.format { async = true }
            end, {buffer = ev.buf, desc = "Format"})
        end,
    })
end

return M
