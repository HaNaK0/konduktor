require('collision.handler')
PickupSystems = {}

---@class PickupHandler
---@field held_pickup PickupComponent?

---@param pickup PickupComponent
---@param translate TranslateComponent
---@param rect RectComponent
---@param collider ColliderComponent
---@param handler PickupHandler
---@param mouse Mouse
---@param reciever_handler CollisionHandler
function PickupSystems.pickup_update_system(pickup, translate, rect, collider, handler, mouse, reciever_handler)
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
			local hits = CollisionHandler.check_collionsions(reciever_handler,
				{translate = translate, rect = rect, collider = collider},
				{"Rect", "Collider", "Translate"})

			if #hits > 0 then
				Info("Collission hit ", #hits)
			end
		end
	end
end

return PickupSystems
