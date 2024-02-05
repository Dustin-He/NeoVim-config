local toggleterm = {{
    'akinsho/toggleterm.nvim',
    version = "*",
    lazy = "true",
    opts = {
        open_mapping = [[<c-\>]],
        -- insert_mapping = true, -- normal mapping does not work if true
        terminal_mapping = true,
        direction = 'float',
        float_opts = {
            border = 'curved',
        }
    },
}}

return toggleterm
