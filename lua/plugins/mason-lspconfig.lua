local servers_ok, servers = pcall(require, "plugins.lsp.servers")
if not servers_ok then
    vim.notify("Servers not found\n", vim.log.levels.DEBUG)
    return
end

local mason_lspconfig = {{
    'williamboman/mason-lspconfig.nvim',
    version = "*",
    lazy = false,
    opts = {
        ensure_installed = servers.server_names
    }
}}

return mason_lspconfig
