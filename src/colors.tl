global type Color = {number, number, number, number}
local enum colors
	"RED"
	"GREEN"
	"BLUE"
	"CYAN"
	"WHITE"
	"YELLOW"
end

global Colors <total>: {colors:Color} = {
	["RED"] = {1, 0, 0, 1},
	["GREEN"] = {0, 1, 0, 1},
	["BLUE"] = {0, 0, 1, 1},
	["CYAN"] = {0, 1, 1, 1},
	["WHITE"] = {1, 1, 1, 1},
	["YELLOW"] = {1, 1, 0, 1},
}

return Colors
