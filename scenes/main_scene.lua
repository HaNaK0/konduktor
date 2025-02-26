require("ecs.entity")
require("log")

local ticket_components = {}

---@type NameComponent
ticket_components.name = {
	type = "Name",
	name = "Ticket",
}

---@type TranslateComponent
ticket_components.translate = {
	type = "Translate",
	x = 100,
	y = 100,
}

---@type RectComponent
ticket_components.rect = {
	type = "Rect",
	width = 200,
	height = 100,
}

---@type ColorComponent
ticket_components.color = {
	type = "Color",
	color = require('colors').my_colors.ticket_color
}

local ticket = Entity.new(ticket_components)

return { ticket }

