local function get_query_driver_list()
    -- 1. 定义我们想允许的编译器名称
    local executables = {
        "clang", "clang++",
        "gcc", "g++", "c++",
        "nvcc", "cuda-gdb" -- 增加 nvcc
    }

    local drivers = {}

    -- 2. 总是添加一些标准的绝对路径作为“保底”
    -- 这样即使 PATH 里找不到，也能覆盖标准安装位置
    local standard_paths = {
        "/usr/bin/clang*",
        "/usr/bin/gcc*",
        "/usr/bin/g++*",
        "/usr/local/cuda/bin/nvcc*" -- 标准 CUDA 路径
    }
    for _, p in ipairs(standard_paths) do
        table.insert(drivers, p)
    end

    -- 3. 动态查找 PATH 中的编译器
    for _, exe in ipairs(executables) do
        local path = vim.fn.exepath(exe)
        if path ~= "" then
            -- 如果找到了 (例如 /home/user/anaconda3/bin/gcc)
            -- 我们添加 /home/user/anaconda3/bin/gcc* 以匹配 gcc-9, gcc-11 等
            table.insert(drivers, path .. "*")
        end
    end

    -- 4. 去重并合并为逗号分隔字符串
    -- (简单的去重逻辑，防止 PATH 里就是 /usr/bin 时重复添加)
    local unique_drivers = {}
    local hash = {}
    for _, v in ipairs(drivers) do
        if not hash[v] then
            unique_drivers[#unique_drivers + 1] = v
            hash[v] = true
        end
    end

    return table.concat(unique_drivers, ",")
end

local function get_clangd_path()
    -- 候选路径列表（优先级从高到低）
    local paths = {
        "/opt/homebrew/opt/llvm/bin/clangd", -- Apple Silicon Homebrew
        "/usr/bin/clangd",                   -- Intel Mac Homebrew
        "$HOME/.local/share/nvim/mason/bin/clangd"
    }

    for _, path in ipairs(paths) do
        if vim.fn.executable(path) == 1 then
            return path
        end
    end

    return "clangd"
end

local binary = get_clangd_path()

return {
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
    },
    cmd = {
        -- "/opt/homebrew/opt/llvm/bin/clangd",
        binary,
        -- "--query-driver=/opt/homebrew/opt/llvm/bin/clang",
        "--query-driver=" .. get_query_driver_list(),
        -- "--all-scopes-completion",
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
