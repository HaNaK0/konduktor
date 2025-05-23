require("ecs.system")
require("ecs.entity")

---@alias ResourceCollection {[string]: any}

---@class Game
---@field update_systems SystemCollection
---@field draw_systems SystemCollection
---@field load_systems SystemCollection
---@field entities EntityCollection
---@field resources ResourceCollection

Game = {}

---Create a new game state
---@return Game
function Game.new()
	---@type Game
	return {
		update_systems = Systems.new_collection(),
		draw_systems = Systems.new_collection(),
		load_systems = Systems.new_collection(),
		entities = Entity.new_collection(),
		resources = {}
	}
end

return Game
