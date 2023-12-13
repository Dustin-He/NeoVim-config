local smartim = {{
    "ybian/smartim",
    version="*",
    lazy = false,
    event = { "InsertEnter" },
    config = function ()
        -- default IME mode
        vim.g.smartim_default = "com.apple.keylayout.ABC"
    end
}}

return smartim
