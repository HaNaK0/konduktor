---@class EntityCollection
---@field entities Entity[]

---@class Entity:Component
---@field components table<ComponentType, Component>

Entity = {}
Entity.collection = {}

---Create a new entity
---@return Entity
function Entity.new()
	---@type Entity
	local entity = {
		type = "Entity",
		components = {},
	}

	return entity
end

---add a component to an entity
---@param entity Entity
---@param component Component
function Entity.add_component(entity, component)
	entity.components[component.type] = component
end

local c = Entity.collection

---create an new entity collection
---@return EntityCollection
function c.new()
	---@type EntityCollection
	return { entities = {} }
end


---Filter out the components that are queried for. This will return an entry if there is a entity that has all the components asked for.For example if you send in `{component_type_a, component_type_b}' it will return pairs of components of type a and b for every entity that has components of both type a and b.
---@param collec EntityCollection
---@param include_entity boolean if true it will ad the entity first in the returned list
---@param components ComponentType[] the components that are requested
---@return Component[][]
function c.filter_components(collec, include_entity, components)
	local res = {}
	for _, entity in ipairs(collec.entities) do
		local e = {}
		if include_entity then
			table.insert(e, entity)
		end

		local skip = false
		for _, comp in ipairs(components) do
			if not entity.components[comp] then
				skip = true
				break
			end
			table.insert(e, entity.components[comp])
		end
		if not skip then
			table.insert(res, e)
		end
	end
	return res
end


