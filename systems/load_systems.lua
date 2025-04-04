require('loaders.asset_loader')
require('ecs.entity')
LoadSystems = {}

---the system that loads the sprite component
---@param entity Entity
---@param imageComponent ImageComponent
---@param assets AssetStorage
function LoadSystems.load_sprite_system(entity, imageComponent, assets)
	Trace("Loading image", imageComponent.path)
	local image = AssetLoader.load_image(assets, imageComponent.path)

	if image == nil then
		return
	end

	imageComponent.image = image

	if not entity.components["Rect"] then
		---@type RectComponent
		local rect = {
			type = "Rect",
			height = image:getHeight(),
			width = image:getWidth(),
		}

		Entity.add_component(entity, rect)
	end
end

--- A system that loads the reciever compponets and adds them to their handler
---@param entity Entity the entity
---@param _ RecieverComponent a reciever component that is queried for 
---@param reciever_handler CollisionHandler the collsion handler responsible for recievers.
function LoadSystems.load_reciever_system(entity, _, reciever_handler)
	Entity.add_enteties(reciever_handler.entity_collection, { entity })
end

return LoadSystems
