local scheme = "onedark"

vim.cmd[["colorscheme " .. scheme]]
-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)
-- if not status_ok then
--     vim.notify("Color scheme " .. scheme .. "not found\n")
--     return
-- end
