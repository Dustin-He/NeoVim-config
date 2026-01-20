local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

local ufo = {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
        -- Optional: for a better fold column UI, see documentation for configuration
        "luukvbaal/statuscol.nvim",
    },
    event = "BufReadPost",
    opts = {
        provider_selector = function()
            -- Prioritize treesitter folding, with indent folding as a fallback
            return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        enable_get_fold_virt_text = true,
        override_foldtext = true,
        preview = {
            win_config = {
                winblend = 0,
            }
        }
    },
    init = function()
        -- Global keymaps for convenience
        vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
        vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
        -- Standard vim keymaps like `zc` (close current fold) and `zo` (open current fold) should work by default.
        vim.keymap.set('n', 'zk', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                -- choose one of coc.nvim and nvim lsp
                vim.fn.CocActionAsync('definitionHover')     -- coc.nvim
                vim.lsp.buf.hover()
            end
        end)
    end,
}
return ufo
