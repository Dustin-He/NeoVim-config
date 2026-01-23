local nvimautopairs = {{
    "windwp/nvim-autopairs",
    lazy = true,
    version = "*",
    event = "InsertEnter",
    opts = {
        check_ts = true,
        ts_config = {
            lua = {'string'},-- it will not add a pair on that treesitter node
            javascript = {'template_string'},
            java = false,-- don't check treesitter on java
        },
        fast_wrap = {
          map = "<M-e>",
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey='Comment'
        }
    }
}}

return nvimautopairs
