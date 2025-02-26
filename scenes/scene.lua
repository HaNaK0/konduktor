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

	local ok, chunk, err = pcall(
		love.filesystem.load, path
	)

	chunk = love.filesystem.load(path)
	---@type Entity[]
	local enteties = {}

	if ok and chunk ~= nil then
		enteties = chunk()
	else
		Error("failed to load scene \"", scene_name, "\" :", err)
	end

	return Entity.new_collection(enteties)
end

return Scene
