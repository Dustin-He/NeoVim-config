return {
    on_init = function(client)
        -- 动态识别 venv/conda 路径
        local python_path = vim.fn.exepath("python3")
        if python_path and python_path ~= "" then
            client.config.settings.python.pythonPath = python_path
        end
    end,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
            },
        },
    },
}
