return require("emnt.overlays").lazyspec("git", {
    -- Shows added/deleted/changed lines, adds :Gitsigns blame, etc
    ["lewis6991/gitsigns.nvim"] = {},
    -- Magit like TUI
    ["NeogitOrg/neogit"] = {
        cmd = { "Neogit", "NeogitResetState", "NeogitLog", "NeogitCommit" },
        keys = {
            { "<leader>g", "<cmd>Neogit<cr>", desc = "Open Neogit UI" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
})
