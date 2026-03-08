local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    ui = {
        border = "rounded",
        -- icons = {
        --     cmd = "⌘",
        --     config = "🛠",
        --     event = "📅",
        --     ft = "📂",
        --     init = "⚙",
        --     keys = "🗝",
        --     plugin = "🔌",
        --     runtime = "💻",
        --     require = "🌙",
        --     source = "📄",
        --     start = "🚀",
        --     task = "📌",
        --     lazy = "💤 ",
        -- },
    },
    spec = {
        { import = "plugins" },
        { import = "plugins.ui" },
        { import = "plugins.editor" },
        { import = "plugins.ai" },
        { import = "plugins.tools" },
        {
            dir = vim.fn.stdpath("config") .. "/custom",
            name = "remote-local",
            priority = 1000,
            keys = { "<leader>rc" },
            config = function()
                require("remote").setup({
                    lsp = {
                        library_path_patterns = { "/site%-packages/", "/dist%-packages/" },
                        disable_diagnostics_on_library = true,
                    },
                })
            end,
        },
        {
            dir = "/Users/dustin/.config/nvim/custom/lua/colorscheme",
            name = "nebula_ember",
            enabled = false,
            -- lazy = false,
            -- priority = 1000,
            config = function()
                require("colorscheme").setup({
                    transparent = true,
                    terminal_colors = true,
                    glow = true,
                    glow_strength = "medium"
                })
                -- vim.cmd.colorscheme("nebula_ember")
            end,
        }

    },
})
