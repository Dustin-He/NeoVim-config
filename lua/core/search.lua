-- Replace special characters
local function replaceString(s)
    local replacedString = string.gsub(s, "#", "%%23")
    replacedString = string.gsub(replacedString, " ", "+")
    return replacedString
end

-- Search with google
local function googleSearch(opts)
    local searchString = replaceString(opts.args)
    local url = "https://www.google.com/search?q=" .. searchString
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

-- Search with Baidu
local function baiduSearch(opts)
    local searchString = replaceString(opts.args)
    local url = "https://www.baidu.com/s?ie=utf-8&wd=" .. searchString
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

-- Translate with Google Translate
-- @ [tl=zh|en] Target language
local function googleTranslate(opts)
    local suffix = ""
    local prefix = ""
    local searchString = table.concat(opts.fargs, " ", 2, #opts.fargs)
    if (opts.fargs[1] == "tl=zh") then
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

-- Create User Command
vim.api.nvim_create_user_command("Baidu", baiduSearch, { range = true, nargs = "*" })
vim.api.nvim_create_user_command("Google", googleSearch, { range = true, nargs = "*" })
vim.api.nvim_create_user_command("Scholar", googleScholar, { range = true, nargs = "*", complete = scholarComplete })
vim.api.nvim_create_user_command("Translate", googleTranslate,
    { range = true, nargs = "*", complete = translateComplete })
