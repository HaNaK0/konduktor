require("none")
require("systems.debug_systems")
local log = require("log")
require("game")
require("scenes.scene")
require("drawing.systems")
require("systems.load_systems")

---@type Option<Game>
local game = None

---a system that waits 3 seconds and then starts the load of the game
---@param dt number
---@param start_timer any
---@param update_systems SystemCollection
---@param entities EntityCollection
---@param load_systems SystemCollection
local function start_wait_system(dt, start_timer, update_systems, entities, assets, load_systems)
	start_timer.time = start_timer.time + dt
	if start_timer.time > 1 then
		Debug("Start wait is over")

		local scene = Scene.load_scene("main_scene", load_systems, assets)

		Entity.add_enteties(entities, scene.entities)
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
	Systems.add_system(game.draw_systems,
		DrawSystems.draw_image_system,
		"draw_image",
		1,
		false,
		{"Image", "Translate"},
		{"draw_buffer"})
	Systems.add_system(game.draw_systems,
		DrawSystems.draw_buffer_system,
		"draw_buffer",
		2,
		false,
		{},
		{"draw_buffer"})

	Systems.add_system(game.update_systems,
		start_wait_system,
		"start_wait",
		1,
		false,
		{},
		{"dt" ,"start_timer", "update_systems", "entities", "assets", "load_systems"})

	Systems.add_system(game.load_systems,
		LoadSystems.load_sprite_system,
		"load_system",
		1,
		true,
		{"Image"},
		{"assets"})

	game.resources = {
		dt = 0,
		start_timer = {time = 0},
		update_systems = game.update_systems,
		load_systems = game.load_systems,
		entities = game.entities,
		draw_buffer = {},
		assets = {}
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
