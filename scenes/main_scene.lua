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
	x = 500,
	y = 500,
}

---@type ImageComponent
ticket_components.image = {
	type = "Image",
	path = "assets/sprites/ticket_placeholder_large.png",
}

---@type PickupComponent
ticket_components.pickup = {
	type = "Pickup",
}

local ticket = Entity.new(ticket_components)

return { ticket }

