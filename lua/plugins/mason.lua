local mason = {{
    "williamboman/mason.nvim",
    version = "*",
    cond = (function() return not vim.g.vscode end),
    opts = {
        log_level = vim.log.levels.DEBUG,
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
}}

return mason
