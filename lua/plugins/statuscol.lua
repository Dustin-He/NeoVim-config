local statuscol = {
    "luukvbaal/statuscol.nvim",
    enabled = true,
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            -- configuration goes here, for example:
            relculright = true,
            foldfunc = "builtin",
            setopt = true,
            segments = {
                {
                    text = { builtin.foldfunc },
                    click = "v:lua.ScFa",
                },
                { text = { builtin.lnumfunc, " "}, click = "v:lua.ScLa", },
                {
                    text = { "%s" },
                    click = "v:lua.ScSa"
                },
            }
        })
    end
}

return statuscol
