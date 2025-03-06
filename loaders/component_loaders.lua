require("loaders.asset_loader")

ComponentLoaders = {}

--- Load an image component
---@param component ImageComponent
---@param assets AssetStorage
---@return ImageComponent
ComponentLoaders["Image"] = function (component, assets)
	component.image = AssetLoader.load_image(assets, component.path)
	return component
end

return ComponentLoaders
