local util = {}

function util.screen_space(x, y)
    local width, height, _ = love.window.getMode()

    return x * width, y * height
end

return util