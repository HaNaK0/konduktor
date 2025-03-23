Colors = {}
---@alias Color [number, number, number] | [number, number, number, number]

---@enum color
Colors.colors = {
	RED = { 1, 0, 0 },
	GREEN = { 0, 1, 0 },
	BLUE = { 0, 0, 1 },
	WHITE = {1, 1, 1 },
	YELLOW = {1, 1, 0 },
}

---@enum my_colors
Colors.my_colors = {
	table_color = { 0.561, 0.278, 0.016 },
	ticket_color = { 0.02, 1, 0.573 },
}

return Colors
