-- Google & Baidu search
local function replaceString(s)
    local replacedString = string.gsub(s, "#", "%%23")
    replacedString = string.gsub(replacedString, " ", "+")
    return replacedString
end

local function googleSearch(opts)
    local searchString = replaceString(opts.args)
    local url = "https://www.google.com/search?q=" .. searchString
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

local function baiduSearch(opts)
    local searchString = replaceString(opts.args)
    local url = "https://www.baidu.com/s?ie=utf-8&wd=" .. searchString
    local jobcmd = { "open", "-u", url }
    vim.fn.jobstart(jobcmd)
end

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

vim.api.nvim_create_user_command("Google", googleSearch, { range=true, nargs = "*" })
vim.api.nvim_create_user_command("Baidu", baiduSearch, { range=true, nargs = "*" })
vim.api.nvim_create_user_command("Translate", googleTranslate, { range=true, nargs = "*", complete = function (_,CmdLine,CursorPos)
    local matchString = string.match(CmdLine, "^[%s]*Translate[%s]+tl=")
    if matchString ~= nil and CursorPos == #matchString then
        return {"zh", "en"}
    end
end})

