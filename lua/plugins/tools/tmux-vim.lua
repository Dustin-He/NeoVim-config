local vim_tmux_navigator = {{
    "christoomey/vim-tmux-navigator",
    cond = (function() return not vim.g.vscode end),
}}

return vim_tmux_navigator
