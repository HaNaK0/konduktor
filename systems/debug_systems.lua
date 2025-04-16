require("colors")

DebugSystems = {}

---@class DebugOptions
---@field draw_rect boolean

---a system that draws all rect components
---@param rect RectComponent
---@param translate TranslateComponent
---@param options DebugOptions
function DebugSystems.draw_rect_system(rect, translate, options)
	if not options.draw_rect then
		return
	end

	love.graphics.setColor(Colors.colors.GREEN)
	love.graphics.rectangle("line", translate.x, translate.y, rect.width, rect.height)
end

return DebugSystems
