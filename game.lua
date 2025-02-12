require("ecs.system")
require("ecs.entity")
---@class Game
---@field update_systems SystemCollection
---@field draw_systems SystemCollection
---@field entities EntityCollection
---@field resources {[string]: any}

Game = {}

---Create a new game state
---@return Game
function Game.new()
	---@type Game
	return {
		update_systems = Systems.new_collection(),
		draw_systems = Systems.new_collection(),
		entities = Entity.collection.new(),
		resources = {}
	}
end

return Game
