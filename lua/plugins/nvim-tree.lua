local nvimtree = { {
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
        hijack_cursor = true,
        -- auto_close = true,
        -- filters = { custom = { "^.git$" } },
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        git = {
            enable = true,
            ignore = false,
        },
        modified = {
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
                git_placement = "after",
                modified_placement = "before",
                diagnostics_placement = "signcolumn",
                bookmarks_placement = "before",
                padding = "",
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
} }

return nvimtree
