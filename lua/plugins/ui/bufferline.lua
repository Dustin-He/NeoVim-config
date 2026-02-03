local bufferline = { {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { 'catppuccin', 'nvim-tree/nvim-web-devicons' },
    cond = (function() return not vim.g.vscode end),
    version = "*",
    event = "VeryLazy",
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyDone",
            callback = function()
                vim.cmd [[
                        highlight BufferLineFill guibg=backgorund
                ]]
            end,
        })
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "<leader><tab>", ":BufDel<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>b", ":BufferLinePick<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>B", ":BufferLinePickClose<CR>", opts)
    end,
    config = function()
        require("bufferline").setup({
            options = {
                mode = 'buffers',
                diagnostics = "nvim_lsp",
                themable = true,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = ""
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " "
                            or (e == "warning" and " ")
                            or (e == "hint" and " " or "󰋼 ")
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
                separator_style = "thin",
                -- show_tab_indicators = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                close_command = "BufDel %d", -- can be a string | function, | false see "Mouse actions"
            },
            highlights = require("catppuccin.special.bufferline").get_theme()

        })
    end,
} }

return bufferline
