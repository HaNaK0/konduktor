require("ecs.entity")
require("ecs.system")
---@alias Scene Entity[]

Scene = {
	scene_root = "scenes/",
	---@type SystemCollection
}

---load a scene from a file
---@param scene_name string a scene name formated in the same way as a module but with the scene root as root
---@param load_systems SystemCollection the systems used to load this scene
---@param assets AssetStorage
---@return EntityCollection
function Scene.load_scene(scene_name, load_systems, assets)
	local path = Scene.scene_root ..
		string.gsub(scene_name, "%.", "/") ..
		".lua"

	local sucess, chunk, err= pcall(love.filesystem.load, path)
	---@type Entity[]
	local enteties = {}

	if not sucess then
		Error("failed to load scene \"", scene_name, "\" :", chunk)
	elseif not chunk then
		Error("failed to load scene \"", scene_name, "\" :", err)
	else
		local inner_sucess, res = pcall(chunk)
		if inner_sucess then
			enteties = res
		else
			Error("failed to load scene \"", scene_name, "\" :", res)
		end
	end

	local entity_collection = Entity.new_collection(enteties)

	Systems.execute(load_systems, entity_collection, { assets = assets })

	return entity_collection
end

return Scene
