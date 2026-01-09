vim.api.nvim_set_hl(0, "OrgModeMenuHideCursor", { bg = "#000000", blend = 100 })

local function orgmode_menu_handler(data)
    local Popup = require("nui.popup")
    local NuiLine = require("nui.line")
    local NuiText = require("nui.text")
    local event = require("nui.utils.autocmd").event

    local options = {}
    for _, item in ipairs(data.items) do
        if item.key and item.label:lower() ~= "quit" then table.insert(options, item) end
    end
    if #options == 0 then return end

    local lines = {}
    local max_width = 0
    for _, opt in ipairs(options) do
        local line = NuiLine()
        line:append(NuiText(" " .. opt.key, "Keyword"))
        line:append(NuiText(" ➜ ", "Character"))
        line:append(opt.label .. " ")
        table.insert(lines, line)
        max_width = math.max(max_width, line:width())
    end
    local title = " " .. (data.title or "Menu") .. " "
    max_width = math.max(max_width, vim.fn.strwidth(title))

    local popup = Popup({
        enter = true,
        focusable = false,
        border = {
            style = "rounded",
            text = { top = title, top_align = "center" },
        },
        relative = "editor",
        position = "100%",
        size = { width = math.min(max_width, 80), height = #options },
    })
    popup:mount()
    for i, line in ipairs(lines) do
        line:render(popup.bufnr, -1, i)
    end
    vim.bo[popup.bufnr].modifiable = false
    vim.bo[popup.bufnr].readonly = true

    -- Temporary hide cursor while the menu window is focused
    local guicursor = nil
    if vim.o.guicursor ~= nil then
        guicursor = vim.o.guicursor
        vim.o.guicursor = "a:block-OrgModeMenuHideCursor"
    end

    popup:on(event.BufLeave, function()
        if guicursor ~= nil then vim.o.guicursor = guicursor end
        popup:unmount()
    end, { once = true })

    for _, opt in ipairs(options) do
        popup:map("n", opt.key, function()
            popup:unmount()
            if opt.action then opt.action() end
        end, { noremap = true, nowait = true })
    end

    popup:map("n", "<Esc>", function() popup:unmount() end, { noremap = true })
    popup:map("n", "q", function() popup:unmount() end, { noremap = true })
end

---@module "lazy"
---@type LazySpec[]
return {
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        ---@module "orgmode"
        ---@type OrgConfigOpts
        opts = {
            org_agenda_files = "~/orgfiles/**/*",
            org_default_notes_file = "~/orgfiles/refile.org",
            ui = { menu = { handler = orgmode_menu_handler } },
        },
    },
    { "nvim-orgmode/org-bullets.nvim", opts = {} },
}
