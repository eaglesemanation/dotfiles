---@module "lazy"
---@type LazySpec[]
return {
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
                lua = true,
                luadoc = true,
                markdown = true,
                markdown_inline = true,
                query = true,
                vim = true,
                vimdoc = true,
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
}
