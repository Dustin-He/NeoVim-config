return {
    on_attach = function(client, _)
        if client.server_capabilities then
            client.server_capabilities.hoverProvider = false
        end
    end,
    on_init = function(client)
        client.offset_encoding = "utf-16"
    end,
    init_options = {
        settings = {
            lint = {
                enable = false,
                -- ignore = { "F401" }
            },
        },
    }
}
