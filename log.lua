local colors = require("colors").colors
---@class Message
---@field level LogLevel
---@field text string
---@field time number
---@field persistant boolean

---@class Log
---the log structure
---@field private messages Message[] messages currently shown on screen.
---@field config LogConfig
Log = {}

---@class LogConfig contains options for the log systemm
---@field fade_time number the time during which the message is faded out.
---@field show_time number the time that a message is shown on screen.
Log.config = {
	fade_time = 1,
	show_time = 5,
}

---Log a message to the screen
---@param level LogLevel level of this log
---@param ... any content to be printed.
function Log:log(level, ...)
	local message = "[" .. level .. "]"
	local args = { n = select("#", ...), ... }

	for i = 1, args.n, 1 do
		message = message .. tostring(args[i])
	end

	table.insert(self.messages, { level = self.levels[level], text = message, time = 0, persistent = false })
end

---log a persistant message that can be  pdatedd
---@param level LogLevel
---@param ... any
---@return Message
function Log:log_persistant(level, ...)
	local message = "[" .. level .. "]"
	local args = { n = select("#", ...), ... }

	for i = 1, args.n, 1 do
		message = message .. args[i]
	end

	local msg = { level = self.levels[level], text = message, time = 0, persistent = true }

	table.insert(self.messages, msg)
	return msg
end

---update timers
--- @param dt number time passed since last upddate
function Log:update(dt)
	local old = {}
	for i, msg in ipairs(self.messages) do
		if not msg.persistant then
			msg.time = msg.time + dt
			if msg.time >= self.config.show_time then
				table.insert(old, i)
			end
		end
	end
end

---Call during love draw function
function Log:draw()
	local font = love.graphics.getFont()
	local colored_text = {}
	local screen_width = love.graphics.getWidth()

	for _, msg in ipairs(self.messages) do
		local time_left = self.config.show_time - msg.time
		local alpha = 1
		if time_left <= self.config.fade_time then
			alpha = time_left / self.config.fade_time
		end
		local c = self.colors[msg.level]
		table.insert(colored_text, {c[1], c[2], c[3], alpha})
		table.insert(colored_text, msg.text .. "\n")
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(colored_text, font, 0, 0, screen_width)
end

---Call to set up the log system
---Creates the global functions Error, Warn, Info, Debug and trace which lets you quickly log a message.
---Calling this setup function will also redirect the print fuction to log a message with the linfo level.
function Log:setup()
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

---log a whole table
---@param table table the table to log
---@param level? LogLevel the level to use. Defaults to `INFO`
function Log:log_table(table, level)
	level = level or "INFO"
	local out = "{"
	for key, value in pairs(table) do
		out = out ..
			tostring(key) ..
			":" ..
			tostring(value) ..
			","
	end
	self:log(level, out .. "}")
end

---@enum (key) LogLevel
Log.levels = {
	ERROR = 1,
	WARN = 2,
	INFO = 3,
	DEBUG = 4,
	TRACE = 5,
}

---@type table<LogLevel, color>
Log.colors = {
	colors.RED,
	colors.YELLOW,
	colors.WHITE,
	colors.BLUE,
	colors.GREEN
}

return Log
