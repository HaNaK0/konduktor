local colors = require("colors").colors
---@class Message
---@field level LogLevel
---@field text string
---@field time number

---@class Log
---the log structure
---@field private messages Message[] messages currently shown on screen.
---@field config LogConfig 
local t = {}

---@class LogConfig contains options for the log systemm
---@field fade_time number the time during which the message is faded out.
---@field show_time number the time that a message is shown on screen.
t.config = {
	fade_time = 1,
	show_time = 5,
}

---Log a message to the screen
---@param level LogLevel level of this log
---@param ... any content to be printed.
function t:log(level, ...)
	local message ="[" .. level .. "]"
	local args = table.pack(...)

	for i = 1, args.n, 1 do
		message = message .. args[i]
	end

	table.insert(self.messages, { level = self.levels[level], text = message, time = 0 })
end

---update timers 
--- @param dt number time passed since last upddate 
function t:update(dt)
	for _, msg in ipairs(self.messages) do
		msg.time = msg.time + dt
	end
end

---Call during love draw function
function t:draw()
	local font = love.graphics.getFont()
	for index, msg in ipairs(self.messages) do
		local line_y = font:getHeight() * (index - 1)
		love.graphics.setColor(self.colors[msg.level])
		love.graphics.print(msg.text, 0, line_y)
	end
end

---Call to set up the log system
---Creates the global functions Error, Warn, Info, Debug and trace which lets you quickly log a message. 
---Calling this setup function will also redirect the print fuction to log a message with the linfo level.
function t:setup()
	self.messages = {}
	self.std_print = print
	print = function(...)
		self.std_print(...)
		self:log("INFO", ...)
	end

	Error = function(...)
		self:log("ERROR", ...)
	end

	Warn = function(...)
		self:log("WARN", ...)
	end

	Info = function(...)
		self:log("INFO", ...)
	end

	Debug = function(...)
		self:log("DEBUG", ...)
	end

	Trace = function(...)
		self:log("TRACE", ...)
	end
end

---@enum (key) LogLevel
t.levels = {
	ERROR = 1,
	WARN = 2,
	INFO = 3,
	DEBUG = 4,
	TRACE = 5,
}

---@type table<LogLevel, color>
t.colors = {
	colors.RED,
	colors.YELLOW,
	colors.WHITE,
	colors.BLUE,
	colors.GREEN
}

return t
