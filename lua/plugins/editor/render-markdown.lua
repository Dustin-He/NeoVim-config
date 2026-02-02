local render = {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    -- opts = {},
    ft = { "markdown", "codecompanion" },
    config = function()
        require('render-markdown').setup({
            completions = { lsp = { enabled = true } },
            latex = {
                enabled = true,
                render_modes = true,
                converter = { 'utftex', 'latex2text' },
                highlight = 'RenderMarkdownMath',
                position = 'center',
                top_pad = 0,
                bottom_pad = 0,
            }
        })
    end
}

return render
