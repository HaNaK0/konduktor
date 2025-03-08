PickupSystems = {}

---@class PickupHandler
---@field held_pickup PickupComponent?

---@param pickup PickupComponent
---@param translate TranslateComponent
---@param rect RectComponent
---@param handler PickupHandler
---@param mouse Mouse
function PickupSystems.pickup_update_system(pickup, translate, rect, handler, mouse)
	if handler.held_pickup == nil then
		if love.mouse.isDown(1) and
			mouse.x > translate.x and
			mouse.y > translate.y and
			mouse.x < translate.x + rect.width and
			mouse.y < translate.y + rect.height then
			handler.held_pickup = pickup
		end
	else
		if love.mouse.isDown(1) then
			translate.x = translate.x + mouse.move_x
			translate.y = translate.y + mouse.move_y
		else
			handler.held_pickup = nil
		end
	end
end

return PickupSystems
