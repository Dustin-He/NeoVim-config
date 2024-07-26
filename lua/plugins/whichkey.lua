local whichkey = {
    "folke/which-key.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {{"echasnovski/mini.icons", version = false}},
    -- enabled = true,
    cmd = "WhichKey",
    -- init = function()
    --     vim.o.timeout = true
    --     vim.o.timeoutlen = 1000
    -- end,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- triggers_nowait = {
        --     -- marks
        --     "`",
        --     "'",
        --     "g`",
        --     "g'",
        --     -- registers
        --     '"',
        --     -- "<c-r>",
        --     -- spelling
        --     "z=",
        -- },
        disable = {
            buftypes = { "nofile" },
            filetypes = {'vim'}
        }
    }
}

return whichkey
