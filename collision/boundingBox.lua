local t = {}

function t.impl(table)
    ---An axis aligned bounding box
    ---@class aabb
    ---@field x integer
    ---@field y integer
    ---@field width integer
    ---@field height integer
    local bb = table or { x = 0, y = 0, width = 0, height = 0 }

    ---Return leftmost x
    ---@return integer
    function bb:get_left()
        return self.x
    end

    ---Return rightmost x
    ---@return integer
    function bb:get_right()
        return self.x + self.width
    end

    ---get topmost y
    ---@return integer
    function bb:get_top()
        return self.y
    end

    ---gett bottom y
    ---@return integer
    function bb:get_bottom()
        return self.y + self.height
    end

    ---check this aabb vs a point
    ---@param point_x integer
    ---@param point_y integer
    ---@return boolean
    function bb:vs_point(point_x, point_y)
        return point_x >= self.x and point_x < self.x + self.width and point_y >= self.y and
        point_y < self.y + self.height
    end

    ---check this aabb vs another one
    ---@param other aabb
    ---@return boolean
    function bb:vs_other(other)
        local is_to_the_right = self:get_left() > other:get_right()
        local is_to_the_left = self:get_right() < other:get_left()
        local is_below = self:get_top() > other:get_bottom()
        local is_above = self:get_bottom() < other:get_top()

        return not (is_to_the_left or is_to_the_right or is_below or is_above)
    end
end

return t
