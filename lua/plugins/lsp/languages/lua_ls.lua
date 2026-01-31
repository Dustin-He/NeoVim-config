return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                pathStrict = false, -- This is where magic happens
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                enable = true,
                globals = { 'vim' },
            },
            workspace = {
                library = {
                    [vim.fn.stdpath("config")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    -- vim.env.VIMRUNTIME,
                    ["${3rd}/luv/library"] = true
                },
            },
            completion = {
                callSnippet = "Replace"
            }
        },
    },
}
