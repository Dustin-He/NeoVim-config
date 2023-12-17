local toggleterm = {{
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        open_mapping = [[<c-\>]],
        insert_mapping = true,
        terminal_mapping = true,
        direction = 'float',
        float_opts = {
            border = 'curved',
        }
    },
}}

return toggleterm
