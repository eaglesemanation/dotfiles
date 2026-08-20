local function get_remote()
    -- 1. Try the upstream remote of the current branch
    local upstream_remote = vim.fn.systemlist("git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null")[1]
    if upstream_remote and upstream_remote ~= "" then return upstream_remote:match("^([^/]+)/") end

    -- 2. Fall back to 'origin' if it exists
    local remotes = vim.fn.systemlist("git remote")
    for _, r in ipairs(remotes) do
        if r == "origin" then return "origin" end
    end

    -- 3. Last resort: first remote alphabetically
    return remotes[1]
end

-- Returns a default branch of upstream remote, most of the time just origin/main
local function get_base_branch()
    local remote = get_remote()
    if not remote then
        return "main" -- no remotes at all, just guess
    end

    local head = vim.fn.systemlist("git symbolic-ref refs/remotes/" .. remote .. "/HEAD 2>/dev/null")[1]
    if head and head ~= "" then return remote .. "/" .. head:match("[^/]+$") end

    for _, name in ipairs({ "main", "master" }) do
        if
            vim.fn.system("git rev-parse --verify " .. remote .. "/" .. name .. " 2>/dev/null") ~= ""
            and vim.v.shell_error == 0
        then
            return remote .. "/" .. name
        end
    end

    return remote .. "/main"
end

---@module "lazy"
---@type LazySpec[]
return {
    -- Shows added/deleted/changed lines, adds :Gitsigns blame, etc
    { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
    -- Magit like TUI
    {
        "NeogitOrg/neogit",
        cmd = { "Neogit", "NeogitResetState", "NeogitLog", "NeogitCommit" },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit UI" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            git_services = {
                ["forgejo.emnt.dev"] = {
                    pull_request = "https://${host}/${owner}/${repository}/compare/${branch_name}",
                    commit = "https://${host}/${owner}/${repository}/commit/${oid}",
                    tree = "https://${host}/${owner}/${repository}/src/branch/${branch_name}",
                },
            },
        },
    },
    {
        "esmuellert/codediff.nvim",
        build = ":CodeDiff install",
        cmd = { "CodeDiff" },
        keys = {
            {
                "<leader>gd",
                "<cmd>CodeDiff<cr>",
                desc = "Diff current commit",
            },
            {
                "<leader>gD",
                function() vim.cmd("CodeDiff " .. get_base_branch() .. "...") end,
                desc = "Diff against base branch",
            },
        },
        opts = {
            explorer = {
                view_mode = "tree",
                line_stats = {
                    enabled = true,
                },
            },
        },
    },
}
