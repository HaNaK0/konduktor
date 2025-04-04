---@class EntityCollection
---@field entities Entity[]

---@class Entity:Component
---@field components ComponentCollection

Entity = {}
Entity.entity_mt = {}


---Create a new entity
---@param components? table<number|string,Component> optional components to add to new entity
---@return Entity
function Entity.new(components)
	---@type Entity
	local entity = {
		type = "Entity",
		components = {},
	}

	setmetatable(entity, Entity.entity_mt)
	if components ~= nil then
		Entity.add_components(entity, components)
	end

	Debug(entity)
	return entity
end

---add a component to an entity
---@param entity Entity
---@param component Component
function Entity.add_component(entity, component)
	entity.components[component.type] = component
end

---add a table or an array of components.
---@param entity Entity the entity to add to
---@param components table<number|string,Component>
function Entity.add_components(entity, components)
	for _, component in pairs(components) do
		Entity.add_component(entity, component)
	end
end

---return a string the represents a entity for printing
---@param entity Entity the entity to get a string for
---@return string
function Entity.tostring(entity)
	local res = "entity"
	---@type NameComponent
	local name_comp = entity.components["Name"]
	if name_comp then
		res = res .. "(" .. name_comp.name .. ")"
	end

	res = res .. ", components: {"
	for type, _ in pairs(entity.components) do
		res = res .. type .. ", "
	end
	res = res .. "}"

	return res
end

Entity.entity_mt.__tostring = Entity.tostring

---create an new entity collection
---@param entities? Entity[] optional array of entities.
---@return EntityCollection
function Entity.new_collection(entities)
	---@type EntityCollection
	return { entities = entities or {} }
end

---add several enteies to a collection
---@param collection EntityCollection
---@param enteties (Entity[]|Entity)
function Entity.add_enteties(collection, enteties)
	if enteties.type == "Entity" then
		table.insert(collection.entities, enteties)
	else
		for _, entity in ipairs(enteties) do
			table.insert(collection.entities, entity)
		end
	end
end

---Crete a new entity collection containing all entities from both input collections
---@param collection EntityCollection
---@param otherCollection EntityCollection
---@return EntityCollection
function Entity.merge_collections(collection, otherCollection)
	---@type Entity[]
	local merged_enteties = {}

	for _, e in ipairs(collection.entities) do
		table.insert(merged_enteties, e)
	end

	for _, e in ipairs(otherCollection.entities) do
		table.insert(merged_enteties, e)
	end

	return Entity.new_collection(merged_enteties)
end

---Filter out the components that are queried for. This will return an entry if there is a entity that has all the components asked for.For example if you send in `{component_type_a, component_type_b}' it will return pairs of components of type a and b for every entity that has components of both type a and b.
---@param collec EntityCollection
---@param include_entity boolean if true it will ad the entity first in the returned list
---@param components ComponentType[] the components that are requested
---@return Component[][]
function Entity.filter_components(collec, include_entity, components)
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
