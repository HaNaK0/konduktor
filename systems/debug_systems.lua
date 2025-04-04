DebugSystems = {}


---a system that draws all rect components
---@param rect RectComponent
---@param translate TranslateComponent
---@param color ColorComponent
function DebugSystems.draw_rect_system(rect, translate, color)
	love.graphics.setColor(color.color)
	love.graphics.rectangle("line", translate.x, translate.y, rect.width, rect.height)
end

return DebugSystems
