local colors = require("colors").colors
---@class Message
---@field level number
---@field text string
---@field time number
---@field key string? the key for this message if it is persistant otherwise this will be nil

---@class Log
---the log structure
---@field private messages Message[] messages currently shown on screen.
---@field private persistant_messages {[string]: Message} persistant mesages
---@field config LogConfig
Log = {}

---@class LogConfig contains options for the log systemm
---@field fade_time number the time during which the message is faded out.
---@field show_time number the time that a message is shown on screen.
---@field log_file string? the name of the log file or nil if the program should not log to file
---@field log_level LogLevel set the log level to show this and more severe logs.
Log.config = {
	fade_time = 1,
	show_time = 5,
	log_file = "log.txt",
	log_level = "TRACE",
}

---Log a message to the screen
---@param level LogLevel level of this log
---@param ... any content to be printed.
function Log:log(level, ...)
	if self.levels[level]  > self.levels[self.config.log_level] then
		return
	end

	local message = "[" .. level .. "]"
	local args = { n = select("#", ...), ... }

	for i = 1, args.n, 1 do
		message = message .. tostring(args[i])
	end

	table.insert(self.messages, { level = self.levels[level], text = message, time = 0})
	if self.config.log_file then
		local success, err = love.filesystem.append(self.config.log_file, message .. "\n")
		assert(success, err)
	end
end

---Log a message once and update it every time this function is
---called again with the same key
---@param level LogLevel
---@param key string a unique key that is used to identify the message
---@param ... any the content to be logged
function Log:log_persistent(level, key, ...)
	if self.levels[level]  > self.levels[self.config.log_level] then
		return
	end

	local message = "[" .. level .. "]"
	local args = { n = select("#", ...), ... }

	for i = 1, args.n, 1 do
		message = message .. tostring(args[i])
	end

	if not self.persistant_messages[key] then
		---@type Message
		local msg = { level = self.levels[level], text = message, time = 0, key = key}
		self.persistant_messages[key] = msg
		table.insert(self.messages, msg)
		return
	end

	local msg = self.persistant_messages[key]
	msg.text = message .. msg.time

	msg.time = 0
end

---update timers
--- @param dt number time passed since last upddate
function Log:update(dt)
	local old = {}
	for i, msg in ipairs(self.messages) do
		msg.time = msg.time + dt
		if msg.time >= self.config.show_time then
			table.insert(old, i)
			if msg.key then
				self.persistant_messages[msg.key] = nil
			end
		end
	end

	for _, index in ipairs(old) do
		table.remove(self.messages, index)
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
	self.persistant_messages = {}
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

	if self.config.log_file then
		love.filesystem.write(self.config.log_file, "")
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
