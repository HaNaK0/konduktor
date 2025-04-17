require("ecs.entity")
require("log")
require("colors")

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
	depth = 1
}

---@type PickupComponent
ticket_components.pickup = {
	type = "Pickup",
}

---@type ColliderComponent
ticket_components.collider = {
	type = "Collider"
}

local ticket = Entity.new(ticket_components)

local table_components = {}

---@type NameComponent
table_components.name = {
	type = "Name",
	name = "Table",
}

---@type TranslateComponent
table_components.translate = {
	type = "Translate",
	x = 50,
	y = 50,
}

---@type ColliderComponent
table_components.collider = {
	type = "Collider"
}

---@type RecieverComponent
table_components.reciever = {
	type = "Reciever"
}

---@type ImageComponent
table_components.image = {
	type = "Image",
	path = "assets/sprites/table_placeholder.png",
	depth = 10,
}

local konduktor_table = Entity.new(table_components)

return { ticket, konduktor_table }

