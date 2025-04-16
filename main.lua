require("none")
require("systems.debug_systems")
local log = require("log")
require("game")
require("scenes.scene")
require("drawing.systems")
require("systems.load_systems")
require('systems.pickup_systems')
require('systems.mouse_systems')

---@type Option<Game>
local game = None

---a system that waits 3 seconds and then starts the load of the game
---@param dt number
---@param start_timer any
---@param update_systems SystemCollection
---@param entities EntityCollection
---@param resources ResourceCollection
---@param load_systems SystemCollection
local function start_wait_system(dt, start_timer, update_systems, entities, resources, load_systems)
	start_timer.time = start_timer.time + dt
	if start_timer.time > 1 then
		Debug("Start wait is over")

		local scene = Scene.load_scene("main_scene", load_systems, resources)

		Entity.add_enteties(entities, scene.entities)
		Systems.remove_system(update_systems,
			"start_wait")
	end
end

function love.load()
	log:setup()
	game = Game.new()
	-- draw systems
	Systems.add_system(game.draw_systems,
		DebugSystems.draw_rect_system,
		"draw_rectangle",
		5,
		false,
		{ "Rect", "Translate"},
		{ "debug_options" }
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

	-- update systems
	Systems.add_system(game.update_systems,
		start_wait_system,
		"start_wait",
		1,
		false,
		{},
		{"dt" ,"start_timer", "update_systems", "entities", "resources", "load_systems"})

	Systems.add_system(game.update_systems,
		MouseSystems.update_mouse_system,
		"update_mouse",
		0,
		false,
		{},
		{"mouse"})

	Systems.add_system(game.update_systems,
		PickupSystems.pickup_update_system,
		"pickup_update",
		2,
		false,
		{"Pickup", "Translate", "Rect", "Collider"},
		{"pickup_handler", "mouse", "reciever_handler"})

	-- load systems
	Systems.add_system(game.load_systems,
		LoadSystems.load_sprite_system,
		"load_image_system",
		1,
		true,
		{"Image"},
		{"assets"})

	Systems.add_system(game.load_systems,
		LoadSystems.load_reciever_system,
		"load_reciever",
		1,
		true,
		{"Reciever"},
		{"reciever_handler"})

	game.resources = {
		dt = 0,
		start_timer = {time = 0},
		update_systems = game.update_systems,
		load_systems = game.load_systems,
		entities = game.entities,
		draw_buffer = {},
		assets = {},
		---@type Mouse
		mouse = {x = love.mouse.getX(), y = love.mouse.getY(), move_x = 0, move_y = 0},
		---@type PickupHandler
		pickup_handler = {},
		reciever_handler = {entity_collection = Entity.new_collection({})},
		---@type DebugOptions
		debug_options = { draw_rect = true },
	}
	game.resources.resources = game.resources

	Info("loading done")
end

function love.draw()
	love.graphics.setBackgroundColor(0.188, 0.757, 1, 1)

	Systems.execute(game.draw_systems, game.entities, game.resources)
	log:draw()
end

function love.update(dt)
	log:update(dt)
	game.resources.dt = dt
	Systems.execute(game.update_systems, game.entities, game.resources)
end

function love.resize(w, h)
	Debug(("window resized to (%d, %d)"):format(w, h))
end
