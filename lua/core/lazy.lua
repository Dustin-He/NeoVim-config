local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local opt = vim.opt

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("Lazy.nvim is not ready")
    return
end

lazy.setup({
    ui = {
        border = "rounded",
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,                                                  -- reset the package path to improve startup time
        rtp = {
            reset = false,                                                      -- reset the runtime path to $VIMRUNTIME and your config directory
            paths = { '/opt/homebrew/Cellar/neovim/0.9.4/share/nvim/runtime' }, -- add any custom paths here that you want to includes in the rtp
            disabled_plugins = {
                -- "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                -- "tarPlugin",
                -- "tohtml",
                -- "tutor",
                -- "zipPlugin",
            },
        },
    },
    spec = { import = "plugins" },
})
