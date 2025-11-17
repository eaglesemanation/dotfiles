---@module "lazy"
---@type LazySpec[]
return {
    -- Green-ish colorscheme
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        main = "everforest",
        priority = 1000,
        config = function()
            require("everforest").setup({
                background = "hard",
                dim_inactive_windows = true,
                on_highlights = function(hl, palette) hl.StatusLine = { bg = palette.none } end,
            })
            vim.cmd.colorscheme("everforest")
        end,
    },

    -- File manager that works like regular buffer
    {
        "stevearc/oil.nvim",
        version = "*",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        lazy = false,
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },

    -- Status line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                component_separators = "│",
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { { "mode", separator = { left = " " }, right_padding = 2 } },
                lualine_b = { "filename", "branch" },
                lualine_c = {},
                lualine_x = { "overseer" },
                lualine_y = { "filetype", "progress" },
                lualine_z = {
                    { "location", separator = { right = " " }, left_padding = 2 },
                },
            },
        },
        config = function(_, opts)
            local theme = require("lualine.themes.everforest")
            for k, _ in pairs(theme) do
                theme[k].c.bg = nil
            end
            opts.options.theme = theme
            require("lualine").setup(opts)
        end,
    },

    -- Icon provider, sets correct highlight for nerdfont icons
    { "nvim-mini/mini.icons", version = false, opts = {} },
    -- Fuzzy finder
    {
        "nvim-mini/mini.pick",
        version = false,
        opts = {
            pickers = {
                registry = function()
                    local pick = require("mini.pick")
                    local items = vim.tbl_keys(pick.registry)
                    table.sort(items)
                    local source = { items = items, name = "Registry", choose = function() end }
                    local chosen_picker_name = pick.start({ source = source })
                    if chosen_picker_name == nil then return end
                    return pick.registry[chosen_picker_name]()
                end,
            },
        },
        cmd = "Pick",
        keys = {
            { "<leader>ff", "<cmd>Pick files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Grep all files in cwd" },
            { "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Show all diagnostics in a buffer" },
        },
        config = function(_, opts)
            local pick = require("mini.pick")
            pick.setup(opts)
            for name, picker in pairs(opts.pickers) do
                pick.registry[name] = picker
            end
        end,
    },
    -- Extra pickers for mini.pick
    { "nvim-mini/mini.extra", version = false, opts = {} },

    -- Notifications and lsp status
    {
        "j-hui/fidget.nvim",
        version = "*",
        opts = {},
        config = function(_, opts)
            local fidget = require("fidget")
            fidget.setup(opts)
            vim.notify = fidget.notify
        end,
    },

    -- Tooltip ui
    {
        "folke/which-key.nvim",
        version = "*",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        ---@module 'which-key'
        ---@type wk.Opts
        opts = {
            preset = "helix",
            delay = 500,
            icons = {
                rules = false,
            },
        },
    },
}
