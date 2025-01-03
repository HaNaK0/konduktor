local boundingBox = require("collision.boundingBox")
local t = {}

function t.new(color, x, y, width, height)
    ---@class dragable: aabb
    ---@field color table
    local item = boundingBox.impl_aabb()

    item.color = color
    item.x = x
    item.y = y
    item.width = width
    item.height = height

    return item
end

return t
