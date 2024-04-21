---@meta

---@class middleclass
local middleclass = {}

---@type string
middleclass._VERSION = nil

---@type string
middleclass._DESCRIPTION = nil

---@type string
middleclass._URL = nil

---@type string
middleclass._LICENSE = nil

---@param name string
---@param super? any
---@return middleclass.Class
function middleclass.class(name, super) end

---@class middleclass.Class
---@field name string
---@field super middleclass.Class?
---@field static middleclass.Class
---@field __instanceDict table
---@field __declaredMethods table
---@field __subclasses { [middleclass.Class]: true? }
local ObjectClass = {}

---@return middleclass.Object instance
function ObjectClass:allocate() end

---@param ... any
---@return middleclass.Object instance
function ObjectClass:new(...) end

---@param name string
---@return middleclass.Class subclass
function ObjectClass:subclass(name) end

---callback for `ObjectClass:subclass`
---@param subclass middleclass.Class
function ObjectClass:subclassed(subclass) end

---@param other middleclass.Class
---@return boolean
function ObjectClass:isSubclassOf(other) end

---@param ... middleclass.Mixin
---@return middleclass.Class self
function ObjectClass:include(...) end

---@class middleclass.Object
---@field class middleclass.Class
local Object = {}

---@return string
function Object:__tostring() end

---@param ... any
function Object:initialize(...) end

---@param aClass middleclass.Class
---@return boolean
function Object:isInstanceOf(aClass) end

---@class middleclass.Mixin
---@field static table
---@field included fun(self: middleclass.Mixin, aClass: middleclass.Class)
local Mixin = {}

return middleclass
