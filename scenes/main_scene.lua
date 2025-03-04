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

---@type ImageComponent
ticket_components.image = {
	type = "Image",
	image = love.graphics.newImage("assets/ticket_placeholder.png")
}

local ticket = Entity.new(ticket_components)

return { ticket }

