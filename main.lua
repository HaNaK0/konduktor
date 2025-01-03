local util = require("util")

function love.load()
    
end

function love.draw()
    love.graphics.setBackgroundColor(0.188, 0.757, 1, 1)

    -- Draw table
    love.graphics.setColor(0.561, 0.278, 0.016)

    local x , y = util.screen_space(0.05, 0.5)
    local width, height = util.screen_space(0.9, 0.45)

    love.graphics.rectangle("fill", x, y, width, height )
end

function love.update(dt)
    
end