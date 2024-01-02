local opt = vim.opt

-- Open files larger than 1 GB
local augroup_large = vim.api.nvim_create_augroup("large_file_cmds", { clear = true })
vim.api.nvim_create_autocmd({"BufAdd", "BufEnter", "BufReadPre" }, {
    pattern = "*",
    group = augroup_large,
    once = true, -- curious?
    callback = function()
        local largeFileSize = 1024 * 1024 * 1024
        local fileSize = vim.fn.getfsize(vim.fn.expand("<afile>"))
        if fileSize < largeFileSize then
            -- Code folding
            opt.foldmethod = "expr"
            opt.foldexpr = "nvim_treesitter#foldexpr()"
            local augroup_folding = vim.api.nvim_create_augroup("code_folding_cmds", { clear = true })
            vim.api.nvim_create_autocmd(
                { "TextYankPost", "TextChanged",
                    "TextChangedT", "BufWinEnter", "VimEnter",
                    "BufAdd", "BufRead", "FileReadPost" },
                {
                    pattern = "*",
                    group = augroup_folding,
                    command = "normal zR",
                    -- nested = true
                })
            -- Plugins loading
            require("core.lazy")
            -- Nvim-tree
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
        else
            vim.cmd[[filetype off]]
            vim.cmd[[syntax off]]
            opt.wrap = false
            opt.ttyfast = true
            opt.hlsearch = false
            opt.autoindent = false
            opt.smartindent = false
        end
    end
})

local augroup_comment = vim.api.nvim_create_augroup("comment_highlight_cmds", { clear = true })
vim.api.nvim_create_autocmd({ "BufNew", "VimEnter", "BufWinEnter", "BufRead", "FileReadPost" }, {
    pattern = "*.tex",
    group = augroup_comment,
    command = "highlight Normal guifg=#CFF6FA"
})

-- Restore cursor
vim.cmd [[autocmd BufRead * autocmd FileType <buffer> ++once if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
