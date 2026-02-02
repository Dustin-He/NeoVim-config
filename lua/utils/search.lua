-- Replace special characters
local function replaceString(s)
    local replacedString = string.gsub(s, "#", "%%23")
    replacedString = string.gsub(replacedString, " ", "+")
    return replacedString
end

-- Replace string with registers
local function replaceStringReg(searchString)
    local regContent = ""
    local regOrNot = false
    local tmpString = searchString
    for str in string.gmatch(searchString, "\\*\\=@%S") do
        if string.match(str, "\\+\\=@%S") ~= nil then
        else
            local reg = string.gsub(str, "\\=@", "")
            regContent = vim.fn.getreg(reg)
            tmpString = string.gsub(tmpString, "\\=@%S", regContent, 1)
            regOrNot = true
        end
    end
    return { b = regOrNot, c = tmpString }
end

-- Search with google
local function googleSearch(opts)
    local searchString = opts.args
    local reg = replaceStringReg(searchString)
    if reg.b then
        searchString = reg.c
    end
    searchString = replaceString(searchString)
    local url = "https://www.google.com/search?q=" .. searchString
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

-- Search with Baidu
local function baiduSearch(opts)
    local searchString = opts.args
    local reg = replaceStringReg(searchString)
    if reg.b then
        searchString = reg.c
    end
    searchString = replaceString(searchString)
    local url = "https://www.baidu.com/s?ie=utf-8&wd=" .. searchString
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

-- Translate with Google Translate
-- [tl=zh|en] Target language
local function googleTranslate(opts)
    local suffix = ""
    local prefix = ""
    local searchString = table.concat(opts.fargs, " ", 2, #opts.fargs)
    if opts.fargs[1] == "tl=zh" then
        suffix = "&tl=zh-CN&op=translate"
        prefix = "?sl=en&text="
    elseif opts.fargs[1] == "tl=en" then
        suffix = "&tl=en&op=translate"
        prefix = "?sl=zh-CN&text="
    else
        searchString = opts.fargs[1] .. " " .. searchString
        suffix = "&tl=zh-CN&op=translate"
        prefix = "?sl=auto&text="
    end
    local reg = replaceStringReg(searchString)
    if reg.b then
        searchString = reg.c
    end
    searchString = replaceString(searchString)
    local url = "https://translate.google.com/" .. prefix .. searchString .. suffix
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

-- Search with Google Scholar
local function googleScholar(opts)
    local searchString = ""
    local paramNum = 0
    for i = 1, #opts.fargs, 1 do
        local matchString1 = string.match(opts.fargs[i], "source=[^%s]*")
        local matchString2 = string.match(opts.fargs[i], "syear=[%d]*")
        local matchString3 = string.match(opts.fargs[i], "eyear=[%d]*")
        if matchString1 ~= nil then
            searchString = searchString .. "&as_publication=" .. string.gsub(matchString1, "source=", "")
            paramNum = paramNum + 1
        elseif matchString2 ~= nil then
            searchString = searchString .. "&as_ylo=" .. string.gsub(matchString2, "syear=", "")
            paramNum = paramNum + 1
        elseif matchString3 ~= nil then
            searchString = searchString .. "&as_yhi=" .. string.gsub(matchString3, "eyear=", "")
            paramNum = paramNum + 1
        end
        if i >= 3 then
            break
        end
    end
    searchString = table.concat(opts.fargs, " ", paramNum + 1, #opts.fargs) .. searchString
    local prefix = "?hl=zh-CN&as_q="
    local suffix = "&btnG="
    local url = "https://scholar.google.com/scholar" .. prefix .. searchString .. suffix
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

-- Complete the Scholar command
local function scholarComplete(_, CmdLine, _)
    local argList = { "source=", "syear=", "eyear=" }
    local regex = vim.regex("\\v^\\s*Scholar\\s+((source\\=\\S*\\s+)|(syear\\=\\d*\\s+)|(eyear\\=\\d*\\s+))*$")
    local srcRe = vim.regex("\\vsource\\=\\S*\\s+")
    local syRe = vim.regex("\\vsyear\\=\\d*\\s+")
    local eyRe = vim.regex("\\veyear\\=\\d*\\s+")
    ---@cast regex -nil
    if regex:match_str(CmdLine) ~= nil then
        local function findItem(tbl, val)
            for i = 1, #tbl, 1 do
                if tbl[i] == val then
                    return i
                end
            end
        end
        ---@cast srcRe -nil
        if srcRe:match_str(CmdLine) ~= nil then
            table.remove(argList, findItem(argList, "source="))
        end
        ---@cast syRe -nil
        if syRe:match_str(CmdLine) ~= nil then
            table.remove(argList, findItem(argList, "syear="))
        end
        ---@cast eyRe -nil
        if eyRe:match_str(CmdLine) ~= nil then
            table.remove(argList, findItem(argList, "eyear="))
        end
        return argList
    end
    return {}
end

-- Complete the Translate command
local function translateComplete(_, CmdLine, _)
    local matchString = string.match(CmdLine, "^[%s]*Translate[%s]+$")
    if matchString ~= nil then
        return { "tl=zh", "tl=en" }
    end
    return {}
end

-- Get the cite bib name
local function getRefTitle(def_list)
    local title = ""
    for _, item in ipairs(def_list['items']) do
        local p = "%.bib$"
        if string.match(item.filename, p) then
            -- vim.print(item.filename)
            -- vim.cmd("e " .. item.filename)
            local buf = vim.fn.bufadd(item.filename)
            vim.fn.bufload(buf)
            -- vim.api.nvim_win_set_cursor(0, { item.lnum, item.col })
            -- vim.treesitter.get_parser(buf):parse()
            local node = vim.treesitter.get_node({ bufnr = buf, pos = { item.lnum - 1, item.col - 1 } })
                :next_named_sibling()
            while node ~= nil do
                local text = vim.treesitter.get_node_text(node, buf)
                -- vim.print(text)
                p = "^title%s*=%s*{"
                if string.match(text, p) then
                    -- title = vim.treesitter.get_node_text(node:named_child(1), buf)
                    local first_child = node:named_child(1)
                    title = first_child and vim.treesitter.get_node_text(first_child, buf) or ""
                    break
                else
                    node = node:next_named_sibling()
                end
            end
            if title ~= "" then
                title = string.gsub(title, "[%^{%^}]", "")
                break
            end
        end
    end
    -- vim.cmd("buffer #")
    return title
end

-- Search the citations
local function searchRefScholar()
    vim.lsp.buf.definition({
        reuse_win = false,
        on_list = function(def_list)
            -- vim.print(def_list)
            local title = getRefTitle(def_list)
            local opts = { fargs = {}, args = title }
            for i in string.gmatch(title, "%S+") do
                table.insert(opts.fargs, i)
            end
            googleScholar(opts)
        end
    })
end

-- Autocmd for searching citations with Google Scholar
local augroup_search_ref = vim.api.nvim_create_augroup("search_ref_cmds", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.tex",
    group = augroup_search_ref,
    callback = function()
        vim.keymap.set("n", "gsr", searchRefScholar,
            { silent = true, noremap = true, buffer = true, desc = "Search the citation" })
    end
})

-- Create User Command
vim.api.nvim_create_user_command("Baidu", baiduSearch, { range = true, nargs = "*" })
vim.api.nvim_create_user_command("Google", googleSearch, { range = true, nargs = "*" })
vim.api.nvim_create_user_command("Scholar", googleScholar, { range = true, nargs = "*", complete = scholarComplete })
vim.api.nvim_create_user_command("Translate", googleTranslate,
    { range = true, nargs = "*", complete = translateComplete })

--- @diagnostic disable: unused-local
local function baiduSearchKey(type, text, s, e)
    -- Char
    -- vim.print("baidu")
    if type == "char" then
        local joinedText = vim.fn.join(text, " ")
        baiduSearch({ args = joinedText })
    end
    -- Line
    if type == "line" then
        local joinedText = vim.fn.join(text, " ")
        baiduSearch({ args = joinedText })
    end
    -- Block
    if type == "block" then
        vim.print("Can not search with Block")
    end
end

--- @diagnostic disable: unused-local
local function googleSearchKey(type, text, s, e)
    -- Char
    if type == "char" then
        local joinedText = vim.fn.join(text, " ")
        googleSearch({ args = joinedText })
    end
    -- Line
    if type == "line" then
        local joinedText = vim.fn.join(text, " ")
        googleSearch({ args = joinedText })
    end
    -- Block
    if type == "block" then
        vim.print("Can not search with Block")
    end
end

--- @diagnostic disable: unused-local
local function scholarSearchKey(dataType, text, s, e)
    if dataType == "char" or dataType == "line" then
        local wordList = {}
        -- Process each line
        for _, line in ipairs(text) do
            if type(line) == "string" then
                -- Split line into words
                local words = vim.fn.split(line, '\\s')
                -- Directly add words to wordList
                for _, word in ipairs(words) do
                    table.insert(wordList, word)
                end
            end
        end
        -- Call translate if we have words
        if #wordList > 0 then
            googleScholar({ fargs = wordList })
        else
            vim.print("No text to translate")
        end
    elseif dataType == "block" then
        vim.print("Cannot translate block selection")
    end
end

--- @diagnostic disable: unused-local
local function translateSearchKey(dataType, text, s, e)
    if dataType == "char" or dataType == "line" then
        local wordList = {}
        -- Process each line
        for _, line in ipairs(text) do
            if type(line) == "string" then
                -- Split line into words
                local words = vim.fn.split(line, '\\s')
                -- Directly add words to wordList
                for _, word in ipairs(words) do
                    table.insert(wordList, word)
                end
            end
        end
        -- Call translate if we have words
        if #wordList > 0 then
            googleTranslate({ fargs = wordList })
        else
            vim.print("No text to translate")
        end
    elseif dataType == "block" then
        vim.print("Cannot translate block selection")
    end
end

require("utils.operator").CreateOperators({ "n", "v" }, "gsb", baiduSearchKey, true, false, "Search with Baidu")
require("utils.operator").CreateOperators({ "n", "v" }, "gsg", googleSearchKey, true, false, "Search with Google")
require("utils.operator").CreateOperators({ "n", "v" }, "gss", scholarSearchKey, true, false, "Search with Google Scholar")
require("utils.operator").CreateOperators({ "n", "v" }, "gst", translateSearchKey, true, false, "Google translate")
