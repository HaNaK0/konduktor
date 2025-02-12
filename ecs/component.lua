---@meta Components
---@alias ComponentType
---| '"Entity"'
---| '"Image"'
---| '"Translate"'
---| '"Rect"'
---| '"Color"'

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
