---@class (exact) None

---@alias Option<T> (None|T)

local mt = {}

function mt.__index()
	assert(false, "trying to index None")
end

function mt.__newindex()
	assert(false,"trying to add to None")
end

function mt.__tostring()
	return "None"
end

---@type None
None = {}
setmetatable(None, mt)
return None
