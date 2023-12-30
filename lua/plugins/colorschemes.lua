-- the colorscheme should be available when starting Neovim
local myColorScheme = {
    {
        "folke/tokyonight.nvim",
        -- version = "*",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },

    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 999,
        config = function()
            require('onedark').setup {
                style = 'darker',
                transparent = false,
                lualine = {
                    transparent = false,
                }
            }
            require('onedark').load()
        end
    }
}

return myColorScheme
