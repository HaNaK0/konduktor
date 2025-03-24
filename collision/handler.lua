require('ecs.entity')
CollisionHandler = {}

---@module "ComponentCollection"

--- Helps handling collsions by storing entities that a valid for this collsion.
---@class CollisionHandler 
---@field entity_collection EntityCollection the entitites that this handler handles

--- Check collisions against all entity that match the components given 
---@param handler CollisionHandler the collision handler to check against
---@param collider_entity {collider: ColliderComponent, translate: TranslateComponent, rect: RectComponent?} a table containing the infomration needed to check a collsion
---@param component_types ComponentType[] a list of components to match aginst, this is matched the same way as for a system
---@return ComponentCollection[]
function CollisionHandler.check_collionsions(handler, collider_entity, component_types)
	local components = Entity.filter_components(handler.entity_collection, false, component_types)
	local res = {}
	for _, comps in ipairs(components) do
		---@type ComponentCollection
		local component_collection = {}
		for index, component in ipairs(comps) do
			component_collection[component_types[index]] = component
		end

		if not component_collection["Collider"] or not component_collection["Rect"] or not component_collection["Translate"] then
			Error("To check collision you need at least a Collider, a Rect and a Translate component")
			return {}
		end

		if not collider_entity.rect then
			local dx = collider_entity.translate.x - component_collection.Translate.x
			local dy = collider_entity.translate.y - component_collection.Translate.y

			if dx >= 0 and
				dx <= component_collection.Rect.width and
				dy >= 0 and
				dy <= component_collection.Rect.height then
				table.insert(res, component_collection)
			end
		else
			local dx = collider_entity.translate.x - component_collection.Translate.x
			local dy = collider_entity.translate.y - component_collection.Translate.y

			if dx >= -collider_entity.rect.width and
				dx <= component_collection.Rect.width and
				dy >= -collider_entity.rect.width and
				dy <= component_collection.Rect.width then
				table.insert(res, component_collection)
			end
		end
	end
	return res
end

return CollisionHandler
