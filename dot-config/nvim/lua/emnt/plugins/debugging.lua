---@module "lazy"
---@type LazySpec[]
return {
    -- Debug Adapter Protocol integration
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        dependencies = {
            -- Nvim Lua debugger
            "jbyuki/one-small-step-for-vimkind",
        },
        keys = {
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc = "Toggle breakpoint",
            },
            {
                "<leader>dB",
                function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
                desc = "Set conditional breakpoint",
            },
        },

        ---@module "dap"
        ---@class emnt.dapOpts
        ---@field configurations dap.Configuration[]
        ---@field adapters dap.Adapter[]

        ---@type emnt.dapOpts
        opts = {
            configurations = {
                lua = {
                    {
                        type = "nlua",
                        request = "attach",
                        name = "Attach to running Neovim instance",
                    },
                },
            },
            adapters = {
                nlua = function(callback, config)
                    callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
                end,
            },
        },

        config = function(_, opts)
            local breakpoint_icons = {}
            if vim.g.have_nerd_font then
                breakpoint_icons = {
                    Breakpoint = "",
                    BreakpointCondition = "",
                    BreakpointRejected = "",
                    LogPoint = "",
                    Stopped = "",
                }
            else
                breakpoint_icons = {
                    Breakpoint = "●",
                    BreakpointCondition = "⊜",
                    BreakpointRejected = "⊘",
                    LogPoint = "◆",
                    Stopped = "⭔",
                }
            end
            for type, icon in pairs(breakpoint_icons) do
                local tp = "Dap" .. type
                local hl = (type == "Stopped") and "Green" or "Red"
                vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
            end

            local dap = require("dap")
            dap.configurations = opts.configurations
            dap.adapters = opts.adapters
        end,
    },

    { "leoluz/nvim-dap-go", opts = {}, dependencies = { "mfussenegger/nvim-dap" } },

    -- UI for DAP
    {
        "igorlfs/nvim-dap-view",
        ---@module "dap-view"
        ---@type dapview.Config
        opts = {
            auto_toggle = true,
            winbar = { controls = { enabled = true } },
        },
        cmd = { "DapViewToggle", "DapViewOpen" },
        keys = {
            { "<leader>du", "<cmd>DapViewToggle<cr>", desc = "Toggle debug view" },
        },
    },
}
