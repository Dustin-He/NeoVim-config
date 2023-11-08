local nvimtreesitter = {{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- version = "*",
    lazy = false,
    config = function ()
      require("nvim-treesitter.configs").setup({
            ensure_installed = { "json", "yaml", "java", "latex", "c", "go", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "bash", "cpp", "python"},
            auto_install = true,
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = {
                }
            },
            indent = { enable = true },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
                -- termcolors = {
                --     -- "#68a0b0",
                --     -- "#946EaD",
                --     -- "#c7aA6D",
                --     "Black",
                --     "Gold",
                --     "Orchid",
                --     "DodgerBlue",
                --     "Cornsilk",
                --     "Salmon",
                --     "LawnGreen",
                -- },
            }
        })
    end
 }}

 return nvimtreesitter

