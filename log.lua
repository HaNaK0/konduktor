local t = {}

---logs a message
---@param level LogLevels
---@param message string
function t:log(level, message)
	table.insert(self.messages, { level = level, message = message, time = os.time() })
end

---Call during love draw function
function t:draw()
	local font = love.graphics.getFont()
	for index, msg in ipairs(self.messages) do
		local line_y = font:getHeight() * (index - 1)
		love.graphics.print(msg.text, 0, line_y)
	end
end

---Call to set up the log system
function t:setup()
	self.messages = {}
	self.std_print = print
	print = function(...)
		local out = ""
		for _, text in ipairs(arg) do
			out = out .. text
		end
		out = out .. "\n"
		self:log("INFO", out)
	end
end

---@enum (key) LogLevels
t.levels = {
    ERROR = 1,
    WARN = 2,
    INFO = 3,
    DEBUG = 4,
    TRACE = 5,
}

return t
