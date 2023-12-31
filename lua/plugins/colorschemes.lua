-- the colorscheme should be available when starting Neovim
local myColorScheme = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
                background = {         -- :h background
                    light = "latte",
                    dark = "macchiato",
                },
                transparent_background = true, -- disables setting the background color.
                show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
                term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false,            -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15,          -- percentage of the shade to apply to the inactive window
                },
                no_italic = false,              -- Force no italic
                no_bold = false,                -- Force no bold
                no_underline = false,           -- Force no underline
                styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" },    -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = function(colors)
                    return {
                        -- Comment = { fg = colors.flamingo },
                        -- TabLineSel = { bg = colors.pink },
                        -- CmpBorder = { fg = colors.surface2 },
                        -- Pmenu = { bg = colors.none },
                        Todo = {style = {'nocombine'}, bg = colors.none, fg = colors.red}
                    }
                end,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    -- mini = {
                    --     enabled = true,
                    --     indentscope_color = "",
                    -- },
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                    alpha = true,
                    flash = true,
                    mason = true,
                    noice = true,
                    telescope = { enabled = true },
                    whichkey = false,
                    ts_rainbow = true,
                },
            })
            vim.cmd.colorscheme "catppuccin"
        end,
    },

    {
        "folke/tokyonight.nvim",
        -- version = "*",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        -- priority = 998, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            -- vim.cmd([[colorscheme tokyonight-night]])
        end,
    },

    {
        "navarasu/onedark.nvim",
        lazy = false,
        -- priority = 999,
        config = function()
            require('onedark').setup {
                style = 'darker',
                transparent = false,
                lualine = {
                    transparent = false,
                }
            }
            -- require('onedark').load()
        end
    },
}

return myColorScheme
