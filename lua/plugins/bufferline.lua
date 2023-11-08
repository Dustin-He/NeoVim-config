local bufferline = {{
    "akinsho/bufferline.nvim",
    lazy = false,
    -- version = "*",
    opts = {
        options = {
            mode = 'buffers',
            diagnostics = "nvim_lsp",
            offsets = {{
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }},
            hover = {
                enabled = true,
                delay = 200,
                reveal = {'close'}
            },
            indicator = {
                -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
                style = 'underline',
            },
            numbers = "both",
            separator_style = "slant",
            -- show_tab_indicators = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            close_command = "BufDel",       -- can be a string | function, | false see "Mouse actions"
        }
    },
}}

return bufferline
