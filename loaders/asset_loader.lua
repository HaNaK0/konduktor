require("log")

AssetLoader = {}

--- A table keeping track of assets so that they can be reused.
---@class AssetStorage
---@field assets table<string,love.Object>

---Load an image or return the one stored in the asset storage
---@param assets AssetStorage
---@param image_path string path to the image on disk
---@return love.Image?
function AssetLoader.load_image(assets, image_path)
	if assets[image_path] then
		return assets[image_path]
	end

	local succeded, res = pcall(love.graphics.newImage, image_path)
	if succeded then
		assets[image_path] = res
		return res
	else
		Error("Failed to load immage ", image_path, " due to:", res)
		return nil
	end
end


return AssetLoader
