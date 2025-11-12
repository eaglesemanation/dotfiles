local lang_list = {
    "bash",
    "c",
    "css",
    "diff",
    "go",
    "gomod",
    "gitcommit",
    "html",
    "javascript",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
}

vim.api.nvim_create_autocmd({ "Filetype" }, {
    callback = function(event)
        if vim.tbl_contains(lang_list, event.match) then
            vim.treesitter.start(event.buf)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
    end,
})

---@module 'lazy'
---@type [LazySpec]
return {
    -- AST parser for most languages out there, used for highlighting
    -- and other lang aware features like running tests
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function() require("nvim-treesitter").install(lang_list) end,
    },
}
