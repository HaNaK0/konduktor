require('loaders.asset_loader')
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

return LoadSystems
