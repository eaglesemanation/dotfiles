---@module "lazy"
---@type LazySpec[]
return {
    -- Act on surrounding elements, like brackets or quotes
    { "nvim-mini/mini.surround", version = false, opts = {} },
    -- Jump to a location with a couple of first letters
    {
        "ggandor/leap.nvim",
        config = function(_, opts)
            vim.keymap.set(
                "n",
                "<leader>h",
                function() require("leap").leap({ target_windows = { vim.api.nvim_get_current_win() } }) end,
                { desc = "Hop to a visible spot" }
            )
        end,
    },
}
