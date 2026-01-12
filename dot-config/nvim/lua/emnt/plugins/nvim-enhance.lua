local function get_session_name()
    local name = vim.fn.getcwd()
    local branch = vim.trim(vim.fn.system("git branch --show-current"))
    if vim.v.shell_error == 0 then
        return name .. branch
    else
        return name
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc(-1) == 0 then
            require("resession").load(get_session_name(), { dir = "dirsession", silence_errors = true })
        end
    end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function() require("resession").save(get_session_name(), { dir = "dirsession", notify = false }) end,
})

---Making native nvim behaviour better
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
    -- Alternative to mksession, adds extensions support
    {
        "stevearc/resession.nvim",
        opts = {
            extensions = {
                quickfix = {},
                dap = {},
            },
        },
    },
    -- Integration with tmux clipboard history, uses osc52 when ssh is detected, and pushes to system clipboard
    { "ibhagwan/smartyank.nvim" },
}
