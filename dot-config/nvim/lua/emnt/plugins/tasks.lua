return require("emnt.overlays").lazyspec("tasks", {
    -- Running async actions, such as unit tests, builds, generating files, etc
    ["stevearc/overseer.nvim"] = {
        ---@module 'overseer'
        ---@type overseer.Config
        opts = {
            templates = { "builtin" },
        },
    },
    -- Unit test integration
    ["nvim-neotest/neotest"] = {
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            ---@module "neotest"
            ---@type neotest.Config
            config = {},
            -- Cannot require those modules directly in here, lazy.nvim haven't installed them yet
            -- Added logic in config to defer require calls
            consumer_modules = {
                overseer = "neotest.consumers.overseer",
            },
        },
        config = function(_, opts)
            for name, mod in pairs(opts.consumer_modules) do
                opts.config = vim.tbl_deep_extend("force", opts.config, {
                    consumers = {
                        [name] = require(mod),
                    },
                })
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
})
