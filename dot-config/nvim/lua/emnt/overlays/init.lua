local M = {}

---Automatically requires all other modules in emnt.overlays
---and combines them into a list of overlay module names
---@return string[]
M.overlay_modules = function()
    -- Automatically require all other lua files in this directory
    -- Each file should return an array of modules that contain overlays
    local path = vim.fn.stdpath("config") .. "/lua/emnt/overlays/"
    local handle = (vim.uv or vim.loop).fs_scandir(path)
    if not handle then return {} end

    local result = {}
    while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end

        if name:match("%.lua$") and not name:match("init.lua$") then
            local modname = "emnt.overlays." .. name:gsub("%.lua$", "")
            local ok, spec = pcall(require, modname)
            if ok and spec then
                for _, item in ipairs(spec) do
                    table.insert(result, item)
                end
            end
        end
    end
    return result
end

---Applies vim.tbl_deep_extend on a LazySpec array and array from plugins.<modname>
---in vim.g.emnt_overlays
---@module "lazy"
---@param modname string
---@param spec_tbl table<string, LazySpec>
---@return LazySpec[]
M.lazyspec = function(modname, spec_tbl)
    for _, pkg in pairs(vim.g.emnt_overlays) do
        local ok, overlay = pcall(require, pkg .. ".plugins." .. modname)
        if ok then spec_tbl = vim.tbl_deep_extend("force", spec_tbl, overlay) end
    end
    local specs = {}
    for plug_name, spec in pairs(spec_tbl) do
        ---@diagnostic disable-next-line
        table.insert(spec, plug_name)
        table.insert(specs, spec)
    end
    return specs
end

return M
