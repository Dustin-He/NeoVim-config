local mason_lspconfig = {{
    'williamboman/mason-lspconfig.nvim',
    version = "*",
    lazy = false,
    opts = {
        ensure_installed = {
            "clangd",
            "cmake",
            -- "golangci_lint_ls",
            "texlab",
            "html",
            "jsonls",
            "tsserver",
            "lua_ls",
            "marksman",
            "pylsp",
            "rust_analyzer",
            "lemminx",
            "yamlls",
            "jdtls",
            "jsonls"
        }
    }
}}

return mason_lspconfig
