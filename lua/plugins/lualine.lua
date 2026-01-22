package.path = package.path .. ';' .. '/Users/dustin/.local/share/nvim/lazy/lualine.nvim/lua/?.lua'

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

local lualine = {
    "nvim-lualine/lualine.nvim",
    version = "*",
    lazy = false,     --用于Lazyvim中禁用内置插件
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
            lualine_x = { macro, '%S', 'selectioncount', { require('minuet.lualine') }, 'copilot', 'encoding', fileformat, 'filetype' },
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
    config = function(_, opts)
        -- Minuet AI status updater for lualine
        local minuet_lualine = require('minuet.lualine')
        local function setup_global_status()
            vim.g.minuet_processing = false
            vim.g.minuet_n_requests = 0
            vim.g.minuet_n_finished = 0
            vim.g.spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
            vim.g.spinner_symbols_len = #vim.g.spinner_symbols
            vim.g.spinner_index = 1

            local group = vim.api.nvim_create_augroup('MinuetGlobalVars', { clear = true })

            vim.api.nvim_create_autocmd({ 'User' }, {
                pattern = 'MinuetRequestStartedPre',
                group = group,
                callback = function(request)
                    local data = request.data
                    vim.g.minuet_processing = false
                    vim.g.minuet_n_requests = data.n_requests
                    vim.g.minuet_n_finished = 0
                end,
            })

            vim.api.nvim_create_autocmd({ 'User' }, {
                pattern = 'MinuetRequestStarted',
                group = group,
                callback = function()
                    vim.g.minuet_processing = true
                end,
            })

            vim.api.nvim_create_autocmd({ 'User' }, {
                pattern = 'MinuetRequestFinished',
                group = group,
                callback = function()
                    vim.g.minuet_n_finished = vim.g.minuet_n_finished + 1
                    if vim.g.minuet_n_finished >= vim.g.minuet_n_requests then
                        vim.g.minuet_processing = false
                    end
                end,
            })
        end
        setup_global_status()
        minuet_lualine.update_status = function()
            if vim.g.minuet_processing then
                vim.g.spinner_index = (vim.g.spinner_index % vim.g.spinner_symbols_len) + 1
                local request = string.format('%s (%s/%s)', vim.g.spinner_symbols[vim.g.spinner_index],
                    vim.g.minuet_n_finished + 1,
                    vim.g.minuet_n_requests)
                return request
            else
                return "󱚦 Qwen"
            end
        end
        require("lualine").setup(opts)
    end,
}

return lualine
