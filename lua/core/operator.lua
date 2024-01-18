M = {
    __opfunc = function(type)
        print("No defined opfunc: ", type) -- vim.print does not input the value of type
    end,
}

local opts = { expr = true, silent = true, noremap = true, desc = "" }
local optsLinewise = { silent = true, noremap = true, desc = "" }

-- Function for line-wise operator, which saves the mark and restores it
local function saveMarkOP()
    local oldMark = vim.api.nvim_buf_get_mark(0, "m")
    vim.cmd("silent! normal! mm0g@$`m")
    if oldMark[1] ~= 0 and oldMark[2] ~= 0 then
        vim.api.nvim_buf_set_mark(0, "m", oldMark[1], oldMark[2], {})
    end
end

-- Function to register the operatorfunc
local function registerOP(func, linewise, changable)
    if linewise then
        return function()
            require("core.operator").__opfunc = CreateOperatorFunc(func, changable)
            vim.go.operatorfunc = "v:lua.require'core.operator'.__opfunc"
            saveMarkOP()
        end
    else
        return function()
            require("core.operator").__opfunc = CreateOperatorFunc(func, changable)
            vim.go.operatorfunc = "v:lua.require'core.operator'.__opfunc"
            return "g@"
        end
    end
end

-- Get start and end of the selected text. 1-indexed
local function getPositions()
    local positionStart = vim.api.nvim_buf_get_mark(0, "[")
    local positionEnd = vim.api.nvim_buf_get_mark(0, "]")
    if positionStart[1] == 0 or positionEnd[1] == 0 then
        return nil
    else
        return positionStart, positionEnd
    end
end

function CreateOperatorFunc(func, changable)
    local myOpFunc = function(type)
        local s, e = getPositions()
        -- vim.print(s, e)
        if s == nil or e == nil then
            return
        end
        local text = nil
        -- Char
        if type == "char" then
            -- 0-indexed position; row and the start column is inclusive;
            text = vim.api.nvim_buf_get_text(0, s[1] - 1, s[2], e[1] - 1, e[2] + 1, {})
        end
        -- Line
        if type == "line" then
            -- 0-indexed position
            text = vim.api.nvim_buf_get_lines(0, s[1] - 1, e[1], false)
        end
        -- Block
        if type == "block" then
            local oldReg = vim.fn.getreg("m")
            vim.cmd([[norm! gv"my ]])
            text = vim.split(vim.fn.getreg("m"), "\n")
            vim.fn.setreg("m", oldReg)
        end
        -- Change the original text
        if text ~= nil then
            local returnedText = func(type, text, s, e)
            if changable and returnedText ~= nil then
                if type == "line" then
                    vim.api.nvim_buf_set_lines(0, s[1] - 1, e[1], false, returnedText)
                elseif type == "char" then
                    -- Replace the lines in the correct buffer
                    vim.api.nvim_buf_set_text(
                        0,
                        s[1] - 1,
                        s[2],
                        e[1] - 1,
                        e[2] + 1,
                        returnedText
                    )
                elseif type == "block" then
                    -- vim.print("hi")
                    local oldReg = vim.fn.getreg("m")
                    local joinedText = ""
                    for _, v in ipairs(returnedText) do
                        joinedText = joinedText .. v .. "\n"
                    end
                    --- @diagnostic disable: param-type-mismatch
                    vim.fn.setreg("m", joinedText, 'b')
                    vim.cmd([[norm! gv"mp]])
                    vim.fn.setreg("m", oldReg, 'b')
                end
            end
        end
    end
    return myOpFunc
end

-- Function to crate the operator
function M.CreateOperators(mode, mapping, func, linewise, changable, des)
    vim.validate({
        mode = { mode, { "string", "table" } },
        mapping = { mapping, "string" },
        func = { func, "function" },
        linewise = { linewise, "boolean" },
        changable = { changable, "boolean" },
        des = { des, "string" },
    })
    -- Default value of nvim
    vim.o.selection = "inclusive"
    -- Add description for the keymap
    if des ~= "" then
        opts["desc"] = des
    end
    -- Map the key in different modes
    for _, m in ipairs(mode) do
        vim.keymap.set(m, mapping, registerOP(func, false, changable), opts)
    end
    -- Map the key in line pattern
    if linewise then
        mapping = mapping .. mapping:sub(-1, -1)
        vim.keymap.set("n", mapping, registerOP(func, true, changable), optsLinewise)
    end
end

return M
