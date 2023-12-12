local opt = vim.opt

-- Open files larger than 1 GB
local augroup_large = vim.api.nvim_create_augroup("large_file_cmds", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufReadPre"}, {
    pattern = "*",
    group = augroup_large,
    callback = function()
        local largeFileSize = 1024 * 1024 * 1024
        local fileSize = vim.fn.getfsize(vim.fn.expand("<afile>"))
        if fileSize < largeFileSize then
            -- Code folding
            opt.foldmethod = "expr"
            opt.foldexpr = "nvim_treesitter#foldexpr()"
            local augroup_folding = vim.api.nvim_create_augroup("code_folding_cmds", {clear = true})
            vim.api.nvim_create_autocmd({"VimEnter", "BufWinEnter", "BufRead", "FileReadPost"}, {
              pattern = "*",
              group = augroup_folding,
              command = "normal zR"
            })
            -- Plugins loading
            require("core.lazy")
        end
    end
})

-- Colorscheme
require("core.colorscheme")

-- Restore cursor
vim.cmd[[autocmd BufRead * autocmd FileType <buffer> ++once if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
