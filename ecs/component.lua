---@enum (key) ComponentType
ComponentType = {
	Entity = 1,
	Image = 2,
	Translate = 3,
	Name = 4,
	Rect = 5,
	Color = 6,
}

---@class Component
---@field type ComponentType

---@class ImageComponent:Component
---@field image love.Image

---@class RectComponent:Component
---@field width integer
---@field height integer

---@class TranslateComponent:Component
---@field x integer
---@field y integer

---@class ColorComponent:Component
---@field color Color

---@class NameComponent:Component
---@field name string
