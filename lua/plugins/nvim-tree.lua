local nvimtree = {{
    "nvim-tree/nvim-tree.lua",
    -- version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        -- lazy = true
    },
    opts = {
        disable_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        -- auto_close = true,
        git = {
            enable = true,
        },
        renderer = {
            icons = {
                web_devicons = {
                    file = {
                        enable = true,
                        color = true,
                    },
                    folder = {
                        enable = true,
                        color = true,
                    },
                },
                git_placement = "before",
                modified_placement = "after",
                diagnostics_placement = "signcolumn",
                bookmarks_placement = "signcolumn",
                padding = " ",
                symlink_arrow = " ➛ ",
                show = {
                  file = true,
                  folder = true,
                  folder_arrow = true,
                  git = true,
                  modified = true,
                  diagnostics = true,
                  bookmarks = true,
                },
                glyphs = {
                  default = "",
                  symlink = "",
                  bookmark = "󰆤",
                  modified = "●",
                  folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                  },
                  git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                  },
                },
            },
        },
    }
    -- config = function()
    --     require("nvim-tree").setup{}
    -- end
}}

return nvimtree

