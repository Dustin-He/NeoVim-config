return {
    -- root_dir = function(fname)
    --     local root = require("lspconfig.util").root_pattern(
    --         "Makefile",
    --         "configure.ac",
    --         "configure.in",
    --         "config.h.in",
    --         "meson.build",
    --         "meson_options.txt",
    --         "build.ninja",
    --         '.clangd',
    --         '.clang-tidy',
    --         '.clang-format'
    --     )(fname)
    --
    --     if root then return root end
    --
    --     root = require("lspconfig.util").root_pattern(
    --         "compile_commands.json",
    --         "compile_flags.txt"
    --     )(fname)
    --
    --     if root then return root end
    --
    --     -- 确保 fname 是字符串后再调用 find_git_ancestor
    --     if type(fname) == "string" and fname ~= "" then
    --         return require("lspconfig.util").find_git_ancestor(fname)
    --     end
    --
    --     return nil
    -- end,
    -- root_dir = function(fname)
    --     return require("lspconfig.util").root_pattern(
    --         "Makefile",
    --         "configure.ac",
    --         "configure.in",
    --         "config.h.in",
    --         "meson.build",
    --         "meson_options.txt",
    --         "build.ninja",
    --         '.clangd',
    --         '.clang-tidy',
    --         '.clang-format'
    --     )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
    --         fname
    --     ) or require("lspconfig.util").find_git_ancestor(fname)
    -- end,
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
    },
    cmd = {
        "/opt/homebrew/opt/llvm/bin/clangd",
        "--query-driver=/opt/homebrew/opt/llvm/bin/clang",
        "--all-scopes-completion",
        -- "--background-index",
        -- "--clang-tidy",
        -- "--header-insertion=iwyu",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=Webkit",
        -- "--log=verbose",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
}
