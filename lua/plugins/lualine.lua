-- cool function for progress
local progress = function()
    local current_line = vim.fn.line(".")
    local first_line = 1
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    local percent = ""
    if current_line == first_line then
        percent = percent .. "Top "
    elseif current_line == total_lines then
        percent = percent .. "Bot "
    else
        percent = percent .. math.ceil(line_ratio * 100) .. '%% '
    end
    return percent .. chars[index]
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diff = {
    "diff",
    colored = true,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
}

local fileformat = {
    'fileformat',
    symbols = {
        unix = ' UNIX', -- e712
        dos = ' DOS', -- e70f
        mac = ' MAC', -- e711
    },
}

local macro = function()
    local macroReg = vim.fn.reg_recording()
    if macroReg == "" then
        return ""
    end
    return "@" .. macroReg
end

local lualine = {{
    "nvim-lualine/lualine.nvim",
    version = "*",
    lazy = false, --用于Lazyvim中禁用内置插件
    dependencies = { { 'nvim-tree/nvim-web-devicons', lazy = true }, },
    cond = (function() return not vim.g.vscode end),
    opts = {
        options = {
            icons_enabled = true,
            -- theme = 'auto',
            theme = 'catppuccin',
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', diff, 'diagnostics' },
            lualine_c = { "os.date('%c')" },
            lualine_x = { macro, '%S', 'selectioncount', 'copilot', 'encoding', fileformat, 'filetype' },
            lualine_y = { progress },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
    },
} }

return lualine
