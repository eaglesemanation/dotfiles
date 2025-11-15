-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Debug this config by running `INIT_DEBUG=true nvim` and attaching from another nvim instance
if vim.fn.getenv("INIT_DEBUG") ~= vim.NIL then
    local osvpath = vim.fn.stdpath("data") .. "/lazy/one-small-step-for-vimkind"
    if not (vim.uv or vim.loop).fs_stat(osvpath) then
        error("OSV is not installed yet, can't run debug")
    else
        rtp:prepend(osvpath)
        require("osv").launch({ port = 8086, blocking = true })
    end
end

-- Disable unused providers for quicker startup
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Don't limit to 256 colors
vim.o.termguicolors = true

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 500

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", lead = "·" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Recenter after moving half a page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Speed up leader commands
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<Leader>\\", "<C-w><C-v>", { desc = "Split window vertically" })
vim.keymap.set("n", "<Leader>-", "<C-w><C-n>", { desc = "Split window horizontally" })
-- Use <Leader>t to work with tabs
vim.keymap.set("n", "<Leader>tc", "<cmd>tabclose<cr>", { desc = "Close current tab" })
vim.keymap.set("n", "<Leader>th", "<cmd>tabprevious<cr>", { desc = "Move focus to the left tab" })
vim.keymap.set("n", "<Leader>tl", "<cmd>tabnext<cr>", { desc = "Move focus to the right tab" })
vim.keymap.set("n", "<Leader>tH", "<cmd>tabmove -1<cr>", { desc = "Swap current tab with one on the left" })
vim.keymap.set("n", "<Leader>tL", "<cmd>tabmove +1<cr>", { desc = "Swap current tab with one on the right" })

-- Highlight when yanking (copying) text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

require("lazy").setup("emnt.plugins", {
    install = {
        colorscheme = { "everforest" },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        enabled = false,
    },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})

-- vim: ts=2 sts=2 sw=2 et
