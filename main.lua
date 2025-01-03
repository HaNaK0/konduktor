local util = require("util")
local colors = require("colors").colors
local my_colors = require("colors").my_colors
local dragable = require("draggable")

local dragables = {}
local hand = {
    empty = true,
    held_item = nil,
}

function love.load()
    local x, y = util.screen_space(0.5, 0.5)
    local ticket = dragable.new(my_colors.ticket_color, x, y, 75, 50)
    table.insert(dragables, ticket)
    print("loaded")
end

function love.draw()
    love.graphics.setBackgroundColor(0.188, 0.757, 1, 1)

    -- Draw table
    love.graphics.setColor(my_colors.table_color)

    local x, y = util.screen_space(0.05, 0.5)
    local width, height = util.screen_space(0.9, 0.45)

    love.graphics.rectangle("fill", x, y, width, height)

    -- Draw Dragables
    for _, v in pairs(dragables) do
        love.graphics.setColor(v.color)

        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end

    if not hand.empty then
        local item = hand.held_item

        love.graphics.setColor(item.color)
        love.graphics.rectangle("fill", item.x, item.y, item.width, item.height)
    end
end

function love.update(dt)

end

function love.mousemoved(_, _, dx, dy)
    if not hand.empty then
        local item = hand.held_item
        item.x = item.x + dx
        item.y = item.y + dy
    end
end

function love.mousepressed(x, y, button, _)
    if not (button == 1) then
        return
    end

    for index, item in ipairs(dragables) do
        if x >= item.x and x < item.x + item.width and y >= item.y and y < item.y + item.height then
            hand.empty = false
            hand.held_item = table.remove(dragables, index)
        end
    end
end

function love.mousereleased(x, y, button, _)
    if not (button == 1) then
        return
    end

    if not hand.empty then
        hand.empty = true
        table.insert(dragables, hand.held_item)
        hand.held_item = nil
    end
end
