local nvimtree = { {
    "nvim-tree/nvim-tree.lua",
    -- version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        -- lazy = true
    },
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        local function open_nvim_tree(data)
            -- buffer is a directory
            local directory = vim.fn.isdirectory(data.file) == 1

            if not directory then
                return
            end

            -- change to the directory
            vim.cmd.cd(data.file)

            -- open the tree
            require("nvim-tree.api").tree.open()
        end
        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
        vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
    opts = {
        -- hijack_netrw = true,
        -- disable_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
            update_cwd = false,
            ignore_list = {},
        },
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
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')

            local function myopts(desc)
                return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = false }
            end

            api.config.mappings.default_on_attach(bufnr)

            -- Delete mappings
            vim.keymap.del('n', 'J', { buffer = bufnr })
            vim.keymap.del('n', 'K', { buffer = bufnr })

            -- -- Add your mappings
            vim.keymap.set('n', 'v', api.node.open.vertical, myopts('Vertical split open'))
            vim.keymap.set('n', 'h', api.node.open.horizontal, myopts('Horizontal split open'))
            -- ---
        end,
    }
} }

return nvimtree
