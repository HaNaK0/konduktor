MouseSystems = {}

---@class Mouse
---@field x number
---@field y number
---@field move_x number
---@field move_y number


---@param mouse Mouse
function MouseSystems.update_mouse_system(mouse)
	local new_x, new_y = love.mouse.getPosition()

	mouse.move_x = new_x - mouse.x
	mouse.move_y = new_y - mouse.y

	mouse.x, mouse.y = new_x, new_y
end

return MouseSystems
