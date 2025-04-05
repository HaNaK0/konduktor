local colors: any = require("colors")

local record Message 
	level: Log.Level
	text: string
	time: number
	key: string
end

local record LogConfig
	fade_time: number
	show_time: number
	log_file: string
	log_level: Log.Level
	log_colors: {Log.Level:Color}
end

---@class Log
---the log structure
---@field private messages Message[] messages currently shown on screen.
---@field private persistant_messages {[string]: Message} persistant mesages
---@field config LogConfig
global record Log
	messages: {Message}
	persistant_messages: {string:Message}
	config: LogConfig	
	enum Level 
		"TRACE"
		"DEBUG"
		"INFO"
		"WARN"
		"ERROR"
	end
	levels: {Log.Level:number}
	std_print: function(...:any)
end

Log.levels = {
	["TRACE"] = 1,
	["DEBUG"] = 2,
	["INFO"] = 3,
	["WARN"] = 4,
	["ERROR"] = 5,
}

Log.config = {
	fade_time = 1,
	show_time = 5,
	log_file = "log.txt",
	log_level = "TRACE",
	log_colors = {
		["TRACE"] = colors["CYAN"],
		["DEBUG"] = colors["GREEN"],
		["INFO"] = colors["WHITE"],
		["WARN"] = colors["YELLOW"],
		["ERROR"] = colors["RED"],
	}
}

---Log a message to the screen
---@param level LogLevel level of this log
---@param ... any content to be printed.
function Log:log(level:Log.Level, ...:any)
	if self.levels[level]  > self.levels[self.config.log_level] then
		return
	end

	local message = "[" .. level .. "]"
	local args = { n = select("#", ...), ... }

	for i = 1, args.n, 1 do
		message = message .. tostring(args[i])
	end

	table.insert(self.messages, { level = level, text = message, time = 0})
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
function Log:log_persistent(level: Log.Level, key: string, ...)
	if self.levels[level]  > self.levels[self.config.log_level] then
		return
	end

	local message = "[" .. level .. "]"
	local args = { n = select("#", ...), ... }

	for i = 1, args.n, 1 do
		message = message .. tostring(args[i])
	end

	if not self.persistant_messages[key] then
		local msg: Message = { level = level, text = message, time = 0, key = key}
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
function Log:update(dt: number)
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
	local colored_text: {string|Color} = {}
	local screen_width = love.graphics.getWidth()

	for _, msg in ipairs(self.messages) do
		local time_left: number = self.config.show_time - msg.time
		local alpha: number = 1
		if time_left <= self.config.fade_time then
			alpha = time_left / self.config.fade_time
		end
		local c = self.config.log_colors[msg.level]
		table.insert(colored_text, {c[1], c[2], c[3], alpha})
		table.insert(colored_text, msg.text .. "\n")
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(colored_text as string, font, 0, 0, screen_width)
end

---Call to set up the log system
---Creates the global functions Error, Warn, Info, Debug and trace which lets you quickly log a message.
---Calling this setup function will also redirect the print fuction to log a message with the linfo level.
function Log:setup()
	self.messages = {}
	self.persistant_messages = {}

	global Error: function(...:any) = function(...)
		self:log("ERROR", ...)
	end

	global Warn : function(...:any) = function(...)
		self:log("WARN", ...)
	end

	global Info : function(...:any) = function(...)
		self:log("INFO", ...)
	end

	global Debug : function(...:any) = function(...)
		self:log("DEBUG", ...)
	end

	global Trace : function(...:any) = function(...)
		self:log("TRACE", ...)
	end

	if self.config.log_file then
		love.filesystem.write(self.config.log_file, "")
	end
end

---log a whole table
---@param table table the table to log
---@param level? LogLevel the level to use. Defaults to `INFO`
function Log:log_table(t:table , level: Log.Level)
	level = level or "INFO"
	local out = "{"
	for key, value in pairs(t) do
		out = out ..
			tostring(key) ..
			":" ..
			tostring(value) ..
			","
	end
	Log:log(level, out .. "}")
end

---@enum (key) LogLevel
Log.levels = {
	ERROR = 1,
	WARN = 2,
	INFO = 3,
	DEBUG = 4,
	TRACE = 5,
}

return Log
