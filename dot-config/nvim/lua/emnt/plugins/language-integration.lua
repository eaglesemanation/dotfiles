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
    virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
})

return require("emnt.overlays").lazyspec("language-integration", {
    -- Formatters
    ["stevearc/conform.nvim"] = {
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
        },
    },

    -- Linters
    ["mfussenegger/nvim-lint"] = {
        opts = {
            linters_by_ft = {
                sh = { "shellcheck" },
                bash = { "shellcheck" },
                lua = { "luac" },
            },
        },
        config = function(_, opts) require("lint").linters_by_ft = opts.linters_by_ft end,
    },

    -- Predefined configs for LSP
    ["neovim/nvim-lspconfig"] = {
        opts = {
            lsp_by_ft = {
                go = "gopls",
                lua = "lua_ls",
            },
        },
        config = function(_, opts)
            for _, name in pairs(opts.lsp_by_ft) do
                vim.lsp.enable(name)
            end
        end,
    },
    -- Package manager for installing LSP servers, linters, formatters and DAP adapters
    ["mason-org/mason.nvim"] = {
        cmd = "Mason",
        opts = {},
    },
    ["mason-org/mason-lspconfig.nvim"] = {
        opts = {},
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },

    -- Nvim specific Lua LSP setup
    ["folke/lazydev.nvim"] = {
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
})
