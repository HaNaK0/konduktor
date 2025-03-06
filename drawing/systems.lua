DrawSystems = {}

---system that adds images to draw buffer
---@param image ImageComponent
---@param translate TranslateComponent
---@param draw_buffer DrawBuffer
function DrawSystems.draw_image_system(image,translate,draw_buffer)
	local transform = love.math.newTransform(translate.x, translate.y)

	---@type DrawCommand
	local command = {
		depth = 1,
		drawable = image.image,
		transform = transform,
	}

	table.insert(draw_buffer, command)
end

--- a system that draws anything in the draw bufer
---@param draw_buffer DrawBuffer
function DrawSystems.draw_buffer_system(draw_buffer)
	table.sort(draw_buffer, function(first, second)
		return first.depth > second.depth
	end)

	for index, command in ipairs(draw_buffer) do
		if command.drawable then
			love.graphics.draw(command.drawable, command.transform )
		end
		draw_buffer[index] = nil
	end
end

return DrawSystems
