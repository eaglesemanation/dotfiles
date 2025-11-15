---@module "lazy"
---@type LazySpec[]
return {
    -- Running async actions, such as unit tests, builds, generating files, etc
    {
        "stevearc/overseer.nvim",
        ---@module 'overseer'
        ---@type overseer.Config
        opts = {
            templates = { "builtin" },
        },
    },

    -- Unit test integration
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },

        ---@module "neotest"
        ---@class emnt.neotestOpts
        ---@field config neotest.Config
        ---@field consumer_modules table<string, string> Module names that will be required after plugins are installed, to avoid early load

        ---@type emnt.neotestOpts
        opts = {
            config = {},
            consumer_modules = {
                overseer = "neotest.consumers.overseer",
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
