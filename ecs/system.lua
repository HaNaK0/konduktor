require("ecs.entity")
require("log")
Systems ={}

---@class SystemCollection
---@field system_array System[]
---@field systems {string:System}
---@field dirty boolean

function Systems.new_collection()
	---@type SystemCollection
	return {
		systems = {},
		system_array = {},
		dirty = false,
	}
end

---@class System
---@field prio integer prority of this system higher systems are executed first.
---@field target fun(...) the function this system callss
---@field entity boolean if this system needs the entity to be passed to it
---@field components ComponentType[] the components this system operates on
---@field resources any[] the resources this system needs

local system_mt = {}

---for sorting systems
---@param s1 System
---@param s2 System
---@return boolean
function system_mt.__lt(s1, s2)
	return s1.prio < s2.prio
end

---call this systems target function
---@param s System
---@param ... unknown
function system_mt.__call(s, ...)
	s.target(...)
end

---add a new system to system collectionn
---@param collection SystemCollection
---@param target fun(...:unknown)
---@param name string
---@param prio integer
---@param entity boolean
---@param comps ComponentType[]
---@param res string[]
function Systems.add_system(collection, target, name, prio, entity, comps, res)
	---@type System
	local s = {
		entity = entity,
		components = comps,
		resources = res,
		prio = prio,
		target = target,
	}

	setmetatable(s, system_mt)

	collection.systems[name] = s
	collection.dirty = true
end

---sort the systems and mark collection as clean
---@param collection SystemCollection
function Systems.sort_systems(collection)
	if not collection.dirty then
		return
	end

	collection.system_array = {}
	for _, system in pairs(collection.systems) do
		table.insert(collection.system_array, system)
	end

	table.sort(collection, function (s1, s2)
		return s1 > s2
	end)
end

---Remove a system from a collection correctly
---@param collection SystemCollection
---@param system string
function Systems.remove_system(collection, system)
	collection.systems[system] = nil
	collection.dirty = true
end

---execute the systems in a collectionon a collection of enitites
---@param collection SystemCollection
---@param entities EntityCollection
---@param resources {[string]: any}
function Systems.execute(collection, entities, resources)
	Systems.sort_systems(collection)
	for _, system in ipairs(collection.system_array) do
		local res = {}
		for j, resource in ipairs(system.resources) do
			table.insert(res, j, resources[resource])
		end

		if next(system.components) == nil then
			system(unpack(res))
		else
			local ents = Entity.collection.filter_components(entities, system.entity, system.components)
			for _, comps in ipairs(ents) do
				for i,r in ipairs(res) do
					comps[#comps + i] = r
				end
				system(unpack(comps))
			end
		end
	end
end

return Systems
