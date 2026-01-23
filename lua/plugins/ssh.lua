local ssh = {
    "inhesrom/remote-ssh.nvim",
    branch = "master",
    -- branch = "on-list-nvim-11.5-fix",
    lazy = true,
    cmd = {
        "RemoteOpen",
        "RemoteTreeBrowser"
    },
    dependencies = {
        "inhesrom/telescope-remote-buffer", --See https://github.com/inhesrom/telescope-remote-buffer for features
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
        -- nvim-notify is recommended, but not necessarily required into order to get notifcations during operations - https://github.com/rcarriga/nvim-notify
        "rcarriga/nvim-notify",
    },
    config = function()
        require('telescope-remote-buffer').setup(
        -- Default keymaps to open telescope and search open buffers including "remote" open buffers
            {
                fzf = "<leader>zf",
                match = "<leader>mb",
                oldfiles = "<leader>rb"
            }
        )

        -- setup lsp_config here or import from part of neovim config that sets up LSP

        -- local lsp_config = require("lspconfig")
        -- local servers_ok, servers = pcall(require, "plugins.lsp.servers")
        -- local ftype_to_server = {}
        -- if servers_ok then
        --     for _, server in ipairs(servers.server_names) do
        --         local filetypes = require('lspconfig')[server].document_config.default_config.filetypes or {}
        --         for _, ft in ipairs(filetypes) do
        --             ftype_to_server[ft] = server
        --         end
        --     end
        -- else
        --     print("No servers found\n")
        -- end
        -- local settings_ok, pylsp_settings = pcall(require, "plugins.lsp.languages.pylsp")
        -- if not settings_ok then
        --     print("No pylsp settings found\n")
        -- end

        require('remote-ssh').setup({
            on_attach = function(client, bufnr)
                -- 复用全局 LSP on_attach
                if (type(client) == "table") then
                    client = client["dynamic_capabilities"]["client_id"]
                end
                vim.lsp.buf_attach_client(bufnr, client)
                -- 或者调用你定义的函数
                if vim.g.lsp_on_attach then
                    vim.g.lsp_on_attach(client, bufnr)
                end
            end,
            -- capabilities = vim.deepcopy(require('cmp_nvim_lsp').default_capabilities()),
            -- capabilities = vim.lsp.protocol.make_client_capabilities(),
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            -- filtetype_to_server = ftype_to_server,
            filetype_to_server = {
                -- 根据你的需要配置
                python = "pylsp",
                lua = "lua_ls",
                rust = "rust_analyzer",
                c = "clangd",
                cpp = "clangd",
                xml = "lemminx",
                cmake = "cmake-language-server",
                -- javascript = "tsserver",
                -- typescript = "tsserver",
                -- go = "gopls",
                -- java = "jdtls",
                -- bash = "bashls"
            },
            server_configs = {
                clangd = {
                    init_options = require('plugins.lsp.languages.clangd').init_options
                },
                pylsp = {
                    init_options = require('plugins.lsp.languages.pylsp').settings
                }
            },
            -- Async write configuration
            async_write_opts = {
                timeout = 30,           -- Timeout in seconds for write operations
                debug = false,          -- Enable debug logging
                log_level = vim.log.levels.INFO,
                autosave = false,       -- Enable automatic saving on text changes (default: true)
                -- Set to false to disable auto-save while keeping manual saves (:w) working
                save_debounce_ms = 3000 -- Delay before initiating auto-save to handle rapid editing (default: 3000)
            }
        })
    end
}

return ssh
