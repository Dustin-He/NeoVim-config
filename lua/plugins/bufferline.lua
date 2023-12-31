local bufferline = { {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { 'catppuccin', 'nvim-tree/nvim-web-devicons' },
    -- version = "*",
    -- ft = "alpha",
    event = "VeryLazy",
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyDone",
            callback = function()
                -- local backgorund = require("catppuccin.palettes.mocha").base
                local backgorund = require("catppuccin.palettes.macchiato").base
                vim.cmd [[
                        " highlight BufferLineFill guibg=#1F2329  " Theme specific
                        highlight BufferLineFill guibg=backgorund
                        " highlight BufferLineBackground guibg=backgorund
                        " highlight BufferLineBuffer guibg=backgorund
                        " highlight BufferLineBufferVisible guibg=backgorund
                        " highlight BufferLineBufferSelected guibg=backgorund
                        " highlight BufferLineSeperatorSelected guibg=backgorund
                        " highlight BufferLineSeperatorVisible guibg=backgorund
                        " highlight BufferLineSeperator guibg=backgorund
                        " highlight BufferLineTabSeperator guibg=backgorund
                        " highlight BufferLineTab guibg=backgorund
                ]]
            end,
        })
    end,
    config = function()
        require("bufferline").setup({
            options = {
                mode = 'buffers',
                diagnostics = "nvim_lsp",
                themable = true,
                -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
                --     local icon = level:match("error") and " " or " "
                --     return " " .. icon .. count
                -- end,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = ""
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and ""
                            or (e == "warning" and "")
                            or (e == "hint" and "" or "󰋼")
                        s = s .. sym .. n .. " "
                    end
                    return s
                end,
                offsets = { {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left"
                } },
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' }
                },
                indicator = {
                    -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
                    -- style = 'underline',
                    style = 'icon',
                },
                numbers = "both",
                separator_style = "thick",
                -- show_tab_indicators = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                close_command = "BufDel", -- can be a string | function, | false see "Mouse actions"
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get()

        })
    end,
} }

return bufferline
