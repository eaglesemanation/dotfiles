---@module 'lazy'
---@type [LazySpec]
return {
    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
            if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
            return "make install_jsregexp"
        end)(),
        config = function()
            local snippath = vim.fn.stdpath("config") .. "/lua/emnt/snippets/"
            require("luasnip.loaders.from_lua").load({ paths = snippath })
        end,
    },

    -- Completion selector
    {
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "1.*",
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
            },

            sources = {
                default = { "lsp", "path", "snippets", "lazydev" },
                providers = {
                    lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
                },
            },
            snippets = { preset = "luasnip" },

            -- See :h blink-cmp-config-fuzzy for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
        },
    },
}
