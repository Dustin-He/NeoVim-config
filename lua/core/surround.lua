local opts = { noremap = true, silent = true }

-- local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

-- Surround keymaps in visual mode
-- keymap("x", "<leader>sb", "<ESC>`>a)<ESC>`<i(<ESC>", opts)
-- keymap("x", "<leader>sB", "<ESC>`>a}<ESC>`<i{<ESC>", opts)
-- keymap("x", "<leader>s(", "<ESC>`>a)<ESC>`<i(<ESC>", opts)
-- keymap("x", "<leader>s)", "<ESC>`>a)<ESC>`<i(<ESC>", opts)
-- keymap("x", "<leader>s{", "<ESC>`>a}<ESC>`<i{<ESC>", opts)
-- keymap("x", "<leader>s}", "<ESC>`>a}<ESC>`<i{<ESC>", opts)
-- keymap("x", "<leader>s[", "<ESC>`>a]<ESC>`<i[<ESC>", opts)
-- keymap("x", "<leader>s]", "<ESC>`>a]<ESC>`<i[<ESC>", opts)
-- keymap("x", "<leader>s<", "<ESC>`>a><ESC>`<i<<ESC>", opts)
-- keymap("x", "<leader>s>", "<ESC>`>a><ESC>`<i<<ESC>", opts)
-- keymap("x", "<leader>s\"", "<ESC>`>a\"<ESC>`<i\"<ESC>", opts)
-- keymap("x", "<leader>s'", "<ESC>`>a'<ESC>`<i'<ESC>", opts)
-- keymap("x", "<leader>s`", "<ESC>`>a`<ESC>`<i`<ESC>", opts)

local function addSurround(l, r)
    --- @diagnostic disable: unused-local
    return function(type, text, s, e)
        if type == 'char' then
            local num = #text
            text[1] = l .. text[1]
            text[num] = text[num] .. r
        elseif type == 'line' then
            for i, _ in ipairs(text) do
                text[i] = l .. text[i] .. r
            end
        elseif type == 'block' then
            for i, _ in ipairs(text) do
                text[i] = l .. text[i] .. r
            end
        end
        return text
    end
end

require("core.operator").CreateOperators({ "n", "v" }, "<leader>sb", addSurround('(', ')'), true, true, "Add brackets")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s(", addSurround('(', ')'), true, true, "Add brackets")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s)", addSurround('(', ')'), true, true, "Add brackets")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>sB", addSurround('{', '}'), true, true, "Add curly brackets")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s{", addSurround('{', '}'), true, true, "Add curly brackets")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s}", addSurround('{', '}'), true, true, "Add curly brackets")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s[", addSurround('[', ']'), true, true, "Add []")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s]", addSurround('[', ']'), true, true, "Add []")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s<", addSurround('<', '>'), true, true, "Add <>")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s>", addSurround('<', '>'), true, true, "Add <>")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s\"", addSurround('"', '"'), true, true, "Add double quotes")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s'", addSurround('\'', '\''), true, true, "Add single quotes")
require("core.operator").CreateOperators({ "n", "v" }, "<leader>s`", addSurround('`', '`'), true, true, "Add `")

-- get the surround characters
local function getSurround()
    local function findItem(tbl, val)
        for i = 1, #tbl, 1 do
            if tbl[i] == val then
                return i
            end
        end
        return 0
    end
    -- local surroundList = { "(", ")", "[", "]", "{", "}", "'", "\"", "<", ">", "`"}
    local surroundList = { "(", ")", "[", "]", "{", "}" }
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local curChar = vim.fn.getline(row):sub(col + 1, col + 1)
    local id = findItem(surroundList, curChar)
    if id ~= 0 then
        vim.cmd [[normal! mm%]]
        local row2, col2 = unpack(vim.api.nvim_win_get_cursor(0))
        vim.cmd [[normal! `m]]
        if row < row2 or (row == row2 and col < col2) then
            return { 1, curChar }
        elseif (row > row2) or (row == row2 and col > col2) then
            return { 2, curChar }
        end
    elseif curChar == "'" or curChar == "\"" or curChar == "<" or curChar == ">" or curChar == "`" then
        local padding = ""
        if curChar == "\"" then
            padding = "\\"
        end
        -- vim.print(curChar)
        vim.cmd [[normal! mm]]
        local cmds = 'execute "normal! vi' .. padding .. curChar .. '\\<ESC>"'
        -- vim.print(cmds)
        vim.cmd(cmds)
        -- Send <ESC> to exit visual mode if no matched pattern
        local keys = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(keys, "v", false)
        local row2S = vim.fn.line("'<")
        local col2S = vim.fn.col("'<")
        local row2E = vim.fn.line("'>")
        local col2E = vim.fn.col("'>")
        -- col is 1-indexed
        col = col + 1
        if row2S ~= 0 and row2E ~= 0 then
            -- vim.print(row2S, col2S, row2E, col2E, row, col)
            if ((row2S == row and col2S > col)) or ((row2E == row and col2E < col)) then
                return { 3, curChar }
            elseif row2S == row and col2S and col2S == col2E - 1 then
                return { 4, curChar }
            end
        end
    end
    return { 0, '' }
end

-- Delete the surround
local function delSurround()
    local ok = getSurround()
    if (ok[1] == 1) then
        vim.cmd [[normal! %x`mx]]
    elseif (ok[1] == 2) then
        vim.cmd [[normal! %mm%x`mx]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lx`<hx`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<xx`m
        ]]
    end
end

-- Change the surround to ()
local function chSurround_b()
    local ok = getSurround()
    if ok[2] == '(' or ok[2] == ')' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 then
        vim.cmd [[normal! mm%r(`mr)]]
    elseif ok[1] == 1 then
        vim.cmd [[normal! mm%r)`mr(]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr)`<hr(`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r(lr)`m
        ]]
    end
end

-- Change the surround to {}
local function chSurround_B()
    local ok = getSurround()
    if ok[2] == '{' or ok[2] == '}' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 then
        vim.cmd [[normal! mm%r{`mr}]]
    elseif ok[1] == 1 then
        vim.cmd [[normal! mm%r}`mr{]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr}`<hr{`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r{lr}`m
        ]]
    end
end

-- Change the surround to []
local function chSurround_m()
    local ok = getSurround()
    if ok[2] == '[' or ok[2] == ']' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 then
        vim.cmd [[
            normal! mm%r[`mr]
        ]]
    elseif ok[1] == 1 then
        vim.cmd [[
            normal! mm%r]`mr[
        ]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr]`<hr[`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r[lr]`m
        ]]
    end
end

-- Change the surround to <>
local function chSurround_g()
    local ok = getSurround()
    if ok[2] == '<' or ok[2] == '>' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 then
        vim.cmd [[normal! mm%r<`mr>]]
    elseif ok[1] == 1 then
        vim.cmd [[normal! mm%r>`mr<]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr>`<hr<`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r<lr>`m
        ]]
    end
end

-- Change the surround to ''
local function chSurround_q()
    local ok = getSurround()
    if ok[2] == '\'' or ok[2] == '\'' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 or ok[1] == 1 then
        vim.cmd [[normal! mm%r'`mr']]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr'`<hr'`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r'lr'`m
        ]]
    end
end

-- Change the surround to ""
local function chSurround_Q()
    local ok = getSurround()
    if ok[2] == '"' or ok[2] == '"' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 or ok[1] == 1 then
        vim.cmd [[normal! mm%r"`mr"]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr"`<hr"`m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r"lr"`m
        ]]
    end
end

-- Change the surround to ``
local function chSurround_I()
    local ok = getSurround()
    if ok[2] == '`' or ok[2] == '`' then
        vim.cmd [[normal! l]]
        return
    end
    if ok[1] == 2 or ok[1] == 1 then
        vim.cmd [[normal! mm%r``mr`]]
    elseif (ok[1] == 3) then
        vim.cmd [[
            normal! `>lr``<hr``m
        ]]
    elseif (ok[1] == 4) then
        vim.cmd [[
            normal! `<r`lr``m
        ]]
    end
end

-- keymap for delete the surround
vim.keymap.set("n", "<leader>db", delSurround, opts)

-- keymap for change the surround
vim.keymap.set("n", "<leader>cb", chSurround_b, opts)
vim.keymap.set("n", "<leader>c(", chSurround_b, opts)
vim.keymap.set("n", "<leader>c)", chSurround_b, opts)
vim.keymap.set("n", "<leader>cB", chSurround_B, opts)
vim.keymap.set("n", "<leader>c{", chSurround_B, opts)
vim.keymap.set("n", "<leader>c}", chSurround_B, opts)
vim.keymap.set("n", "<leader>c\"", chSurround_Q, opts)
vim.keymap.set("n", "<leader>c'", chSurround_q, opts)
vim.keymap.set("n", "<leader>c`", chSurround_I, opts)
vim.keymap.set("n", "<leader>c[", chSurround_m, opts)
vim.keymap.set("n", "<leader>c]", chSurround_m, opts)
vim.keymap.set("n", "<leader>c<", chSurround_g, opts)
vim.keymap.set("n", "<leader>c>", chSurround_g, opts)
