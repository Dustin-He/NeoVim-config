return {
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                enable = true,
                globals = { 'vim' },
            },
            workspace = {
                library = {
                    [vim.fn.stdpath("config")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                },
            },
        },
    },
}
