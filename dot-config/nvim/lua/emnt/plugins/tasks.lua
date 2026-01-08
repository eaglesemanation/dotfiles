---@module "lazy"
---@type LazySpec[]
return {
    -- Running async actions, such as unit tests, builds, generating files, etc
    {
        "stevearc/overseer.nvim",
        version = "*",
        ---@module 'overseer'
        ---@type overseer.Config
        opts = {
            templates = { "builtin" },
        },
    },

    -- Unit test integration
    {
        "nvim-neotest/neotest",
        version = "*",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",

            {
                "fredrikaverpil/neotest-golang",
                version = "*",
            },
        },

        ---@module "neotest"
        ---@class emnt.neotestOpts
        ---@field config neotest.Config
        ---@field consumer_modules table<string, string> Module names that will be required after plugins are installed, to avoid early load
        ---@field adapters table<string, table | boolean> Module name of an adapter, and a config that will be passed to adapter setup function

        ---@type emnt.neotestOpts
        opts = {
            config = {},
            consumer_modules = {
                overseer = "neotest.consumers.overseer",
            },
            adapters = {
                ---@module "neotest-golang"
                ["neotest-golang"] = {},
                ["rustaceanvim.neotest"] = true,
            },
        },

        ---@param opts emnt.neotestOpts
        config = function(_, opts)
            for name, mod in pairs(opts.consumer_modules) do
                opts.config = vim.tbl_deep_extend("force", opts.config, {
                    consumers = {
                        [name] = require(mod),
                    },
                })
            end

            if not opts.config.adapters then opts.config.adapters = {} end
            for mod, conf in pairs(opts.adapters) do
                local adapter = require(mod)
                if type(conf) == table then adapter = adapter(conf) end
                if conf ~= false then table.insert(opts.config.adapters, adapter) end
            end

            require("neotest").setup(opts.config)
        end,

        cmd = "Neotest",
        keys = {
            { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
            {
                "<leader>tf",
                function() require("neotest").run.run(vim.fn.expand("%")) end,
                desc = "Run tests in the file",
            },
            {
                "<leader>td",
                function() require("neotest").run.run({ strategy = "dap" }) end,
                desc = "Debug nearest test",
            },
            {
                "<leader>tu",
                function() require("neotest").summary.toggle() end,
                desc = "Toggle test UI",
            },
        },
    },
}
