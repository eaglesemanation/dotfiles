local function get_project_path()
    local git_root = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
    if vim.v.shell_error == 0 then
        return git_root
    else
        return nil
    end
end

-- Load session based on git root or cwd
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc(-1) == 0 then
            local resession = require("resession")
            local proj_path = get_project_path()
            if proj_path ~= nil then
                resession.load(proj_path, { silence_errors = true })
            else
                resession.load(vim.fn.getcwd(), { silence_errors = true })
            end
        end
    end,
})
-- Update existing session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local resession = require("resession")
        local session_info = resession.get_current_session_info()
        if session_info ~= nil then resession.save(session_info.name, { notify = false }) end
    end,
})

vim.keymap.set("n", "<leader>sp", function()
    local proj_path = get_project_path()
    if proj_path ~= nil then
        require("resession").save(proj_path)
    else
        vim.notify("Could not find git root", vim.log.levels.ERROR)
    end
end, { desc = "Save project session (git root)" })
vim.keymap.set(
    "n",
    "<leader>sc",
    function() require("resession").save(vim.fn.getcwd()) end,
    { desc = "Save session (cwd)" }
)
vim.keymap.set("n", "<leader>sd", function() require("resession").delete() end, { desc = "Delete a session" })

---Making native nvim behaviour better
---@module "lazy"
---@type LazySpec[]
return {
    -- Act on surrounding elements, like brackets or quotes
    { "nvim-mini/mini.surround", lazy = false, opts = {} },
    -- Jump to a location with a couple of first letters
    {
        "ggandor/leap.nvim",
        lazy = false,
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
    { "ibhagwan/smartyank.nvim", lazy = false, opts = { highlight = { timeout = 500 } } },
}
