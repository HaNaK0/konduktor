local util = {}

---@return integer, integer
---@param x number
---@param y number
function util.screen_space(x, y)
    local width, height, _ = love.window.getMode()

    return x * width, y * height
end

return util