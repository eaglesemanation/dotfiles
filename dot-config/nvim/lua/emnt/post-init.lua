local M = {}

M.run = function()
    local dir = vim.fn.stdpath("config") .. "/lua/emnt/post-init"
    local files = vim.fn.glob(dir .. "/*.lua", true, true)
    for _, file in pairs(files) do
        local mod_name = "emnt.post-init." .. vim.fn.fnamemodify(file, ":t:r")
        local m = require(mod_name)
        if type(m) == "table" and m.run and type(m.run) == "function" then m.run() end
    end
end

return M
