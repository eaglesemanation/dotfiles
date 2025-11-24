vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("LintEnable", function()
    vim.b.disable_autolint = false
    vim.g.disable_autolint = false
end, {
    desc = "Re-enable lint after insert / on save",
})

vim.api.nvim_create_user_command("LintDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autolint = true
    else
        vim.g.disable_autolint = true
    end
end, {
    desc = "Disable lint after insert / on save",
    bang = true,
})

-- Run linters on file save
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function(ev)
        if vim.g.disable_autolint or vim.b[ev.buf].disable_autolint then return end
        require("lint").try_lint()
    end,
})

vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    },
})

vim.keymap.set({ "n" }, "<leader>sd", vim.diagnostic.open_float, { desc = "Show diagnostics" })

---@module "lazy"
---@type LazySpec[]
return {
    { "NMAC427/guess-indent.nvim", opts = {} },

    -- Formatters
    {
        "stevearc/conform.nvim",
        version = "*",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
            },
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
        },
    },

    -- Linters
    {
        "mfussenegger/nvim-lint",

        ---@class emnt.lintOpts
        ---@field linters_by_ft table<string, string[]>

        ---@type emnt.lintOpts
        opts = {
            linters_by_ft = {
                sh = { "shellcheck" },
                bash = { "shellcheck" },
                lua = { "luac" },
            },
        },
        ---@param opts emnt.lintOpts
        config = function(_, opts) require("lint").linters_by_ft = opts.linters_by_ft end,
    },

    -- Predefined configs for LSP
    {
        "neovim/nvim-lspconfig",
        version = "*",

        ---@class emnt.lspconfOpts
        ---@field lsps table<string, boolean>

        ---@type emnt.lspconfOpts
        opts = {
            lsps = {
                gopls = true,
                lua_ls = true,
                tombi = true,
                yamlls = true,
                jsonls = true,
            },
        },
        ---@param opts emnt.lspconfOpts
        config = function(_, opts)
            for lsp, enabled in pairs(opts.lsps) do
                if enabled then vim.lsp.enable(lsp) end
            end
        end,
    },
    -- Package manager for installing LSP servers, linters, formatters and DAP adapters
    {
        "mason-org/mason.nvim",
        version = "*",
        cmd = "Mason",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        version = "*",
        opts = {},
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },

    -- AST parser for most languages out there, used for highlighting
    -- and other lang aware features like running tests
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        opts = {
            langs = {
                bash = true,
                fish = true,
                c = true,
                css = true,
                diff = true,
                go = true,
                gomod = true,
                gitcommit = true,
                html = true,
                javascript = true,
                typescript = true,
                java = true,
                python = true,
                lua = true,
                luadoc = true,
                markdown = true,
                markdown_inline = true,
                query = true,
                vim = true,
                vimdoc = true,
                json = true,
                yaml = true,
                toml = true,
            },
        },
        config = function(_, opts)
            local lang_list = {}
            for lang, enabled in pairs(opts.langs) do
                if enabled then table.insert(lang_list, lang) end
            end
            require("nvim-treesitter").install(lang_list)
            vim.api.nvim_create_autocmd({ "Filetype" }, {
                callback = function(event)
                    if vim.tbl_contains(lang_list, event.match) then
                        vim.treesitter.start(event.buf)
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            })
        end,
    },

    -- Nvim specific Lua LSP setup
    {
        "folke/lazydev.nvim",
        version = "*",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
