require("none")
require("debug_systems")
local my_colors = require("colors").my_colors
local log = require("log")
require("game")

---@type Option<Game>
local game = None

---a system that waits 3 seconds and then starts the load of the game
---@param dt number
---@param start_timer any
---@param update_systems SystemCollection
---@param entities EntityCollection
local function start_wait_system(dt, start_timer, update_systems, entities)
	start_timer.time = start_timer.time + dt
	if start_timer.time > 1 then
		Debug("Start wait is over")
		local entity = Entity.new()
		---@type RectComponent
		local rect = {
			type = "Rect",
			width = 20,
			height = 10
		}
		Entity.add_component(entity, rect)

		---@type ColorComponent
		local col = {
			type = "Color",
			color = my_colors.ticket_color
		}
		Entity.add_component(entity, col)

		---@type TranslateComponent
		local trans = {
			type = "Translate",
			x = 0,
			y = 0,
		}
		Entity.add_component(entity, trans)

		table.insert(entities.entities,
			entity)

		Systems.remove_system(update_systems,
			"start_wait")
	end
end

function love.load()
	log:setup()
	game = Game.new()
	Systems.add_system(game.draw_systems,
		DebugSystems.draw_rect_system,
		"draw_rectangle",
		1,
		false,
		{ "Rect", "Translate", "Color" },
		{}
	)
	Systems.add_system(game.update_systems,
		start_wait_system,
		"start_wait",
		1,
		false,
		{},
		{"dt" ,"start_timer", "update_systems", "entities"})
	game.resources = {
		dt = 0,
		start_timer = {time = 0},
		update_systems = game.update_systems,
		entities = game.entities,
	}

	Info("loading done")
end

function love.draw()
	love.graphics.setBackgroundColor(0.188, 0.757, 1, 1)

	log:draw()

	Systems.execute(game.draw_systems, game.entities, game.resources)
end

function love.update(dt)
	log:update(dt)
	game.resources.dt = dt
	Systems.execute(game.update_systems, game.entities, game.resources)
end

function love.resize(w, h)
	Debug(("window resized to (%d, %d)"):format(w, h))
end
