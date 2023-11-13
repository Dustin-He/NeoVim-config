local lualine = {{
    "nvim-lualine/lualine.nvim",
    version = "*",
    lazy = false, --用于Lazyvim中禁用内置插件
    dependencies = {{'nvim-tree/nvim-web-devicons', lazy = true}},
    opts = {
        options = {
	        icons_enabled = true,
	        theme = 'auto',
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = { "os.date('%c')", 'data', "require'lsp-status'.status()" },
            lualine_x = {'%S', 'selectioncount', 'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
    },
}}

return lualine
