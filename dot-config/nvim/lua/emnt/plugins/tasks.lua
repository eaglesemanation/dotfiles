-- Running async actions, such as unit tests, builds, generating files, etc
---@module 'lazy'
---@type [LazySpec]
return {
    {
        "stevearc/overseer.nvim",
        ---@module 'overseer'
        ---@type overseer.Config
        opts = {
            templates = { "builtin" },
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("neotest").setup({
                consumers = {
                    overseer = require("neotest.consumers.overseer"),
                },
            })
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
