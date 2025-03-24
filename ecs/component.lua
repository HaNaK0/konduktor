---@meta Component

---@class Component
---@field type ComponentType

---@class ImageComponent:Component
---@field image love.Image?
---@field path string
---@field depth number

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

---@class PickupComponent:Component

---@class ColliderComponent:Component

---@class RecieverComponent:Component
