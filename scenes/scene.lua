require("ecs.entity")
---@alias Scene Entity[]

Scene = {
	scene_root = "scenes/"
}

---load a scene from a file
---@param scene_name string a scene name formated in the same way as a module but with the scene root as root
---@return EntityCollection
function Scene.load_scene(scene_name)
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

	return Entity.new_collection(enteties)
end

return Scene
