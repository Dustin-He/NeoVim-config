-- 辅助函数：进度条
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
    symbols = { added = " ", modified = " ", removed = " " },
    cond = hide_in_width,
}

local fileformat = {
    'fileformat',
    symbols = {
        unix = ' UNIX',
        dos = ' DOS',
        mac = ' MAC',
    },
}

local macro = function()
    local macroReg = vim.fn.reg_recording()
    if macroReg == "" then
        return ""
    end
    return "@" .. macroReg
end

return {
    "nvim-lualine/lualine.nvim",
    version = "*",
    lazy = false,
    -- 2. 关键修复：添加 minuet 到依赖列表
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', lazy = true },
        -- 确保这里使用的是你实际安装的 minuet 插件仓库名
        -- 如果你用的是 milanglacier/minuet-ai.nvim：
        { "milanglacier/minuet-ai.nvim" },
    },
    cond = (function() return not vim.g.vscode end),

    -- 3. 将 opts 改为 config 函数内部定义，避免过早 require 导致报错
    config = function()
        -- 安全引入 minuet
        local minuet_lualine = require('minuet.lualine')

        -- 初始化 Minuet 全局状态逻辑
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

        -- 定义 minuet 的具体显示逻辑函数
        -- 这样我们就不需要覆盖 module 的 update_status，直接在这里用这个函数
        local function minuet_component()
            if vim.g.minuet_processing then
                vim.g.spinner_index = (vim.g.spinner_index % vim.g.spinner_symbols_len) + 1
                return string.format('%s (%s/%s)', vim.g.spinner_symbols[vim.g.spinner_index],
                    vim.g.minuet_n_finished + 1,
                    vim.g.minuet_n_requests)
            else
                return "󱚦 Qwen"
            end
        end

        -- 4. 组装配置并启动
        require("lualine").setup({
            options = {
                icons_enabled = true,
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
                lualine_x = {
                    macro,
                    '%S',
                    'selectioncount',
                    -- 直接使用我们上面定义的函数，而不是 { require(...) } 这种容易出错的写法
                    minuet_component,
                    'copilot',
                    'encoding',
                    fileformat,
                    'filetype'
                },
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
        })
    end,
}
