local opt = vim.opt

-- -- Open files larger than 1 GB
-- local augroup_large = vim.api.nvim_create_augroup("large_file_cmds", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "BufReadPre" }, {
--     pattern = "*",
--     group = augroup_large,
--     once = true, -- curious?
--     callback = function()
--         local largeFileSize = 1024 * 1024 * 1024
--         local fileSize = vim.fn.getfsize(vim.fn.expand("<afile>"))
--         if fileSize < largeFileSize then
--             -- Plugins loading
--             require("core.lazy")
--         else
--             vim.cmd [[filetype off]]
--             vim.cmd [[syntax off]]
--             opt.wrap = false
--             opt.ttyfast = true
--             opt.hlsearch = false
--             opt.autoindent = false
--             opt.smartindent = false
--         end
--     end
-- })

-- Disable auto comment
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("disable_auto_comment", { clear = true }),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

local augroup_comment = vim.api.nvim_create_augroup("comment_highlight_cmds", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufNew", "VimEnter", "BufWinEnter", "BufRead", "FileReadPost" }, {
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "tex",
    group = augroup_comment,
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { fg = '#CFF6FA' })
    end
    -- command = "highlight Normal guifg=#CFF6FA"
})

-- Restore cursor
vim.cmd [[autocmd BufRead * autocmd FileType <buffer> ++once if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]

-- Set highlight for trailing spaces
vim.api.nvim_set_hl(0, "TrailingSpace", { bg = '#87787B' })
vim.fn.matchadd("TrailingSpace", "\\s\\+$", -1)
local augroup_trailing = vim.api.nvim_create_augroup("trailing_highlight_cmds", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "alpha",
    group = augroup_trailing,
    command = "call clearmatches()"
})
