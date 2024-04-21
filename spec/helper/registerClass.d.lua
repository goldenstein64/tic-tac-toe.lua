---@meta

---@class luassert.internal
local luassert = {}

---assert that `instance` is an instance of `baseClass`.
---@param baseClass middleclass.Class
---@param instance middleclass.Object
---@param message? string
---@return luassert.internal
function luassert.instance_of(baseClass, instance, message) end

luassert.instance = luassert.instance_of
luassert.instance = { of = luassert.instance_of }
luassert.is_instance_of = luassert.instance_of

---assert that `subClass` is a subclass of `baseClass`.
---@param baseClass middleclass.Class
---@param subClass middleclass.Class
---@param message? string
---@return luassert.internal
function luassert.subclass_of(baseClass, subClass, message) end

luassert.subclass = luassert.subclass_of
luassert.subclass = { of = luassert.subclass_of }
luassert.is_subclass_of = luassert.subclass_of

---@class bustez.Expectation
local expect = {}

---assert that our expectation is an instance of `baseClass`
---@param baseClass middleclass.Class
---@param message? string
---@return bustez.Expectation
function expect.instance_of(baseClass, message) end

expect.instance = expect.instance_of
expect.instance = { of = expect.instance_of }
expect.to_be_an_instance_of = expect.instance_of

---assert that our expectation is an subclass of `baseClass`
---@param baseClass middleclass.Class
---@param message? string
---@return bustez.Expectation
function expect.subclass_of(baseClass, message) end

expect.subclass = expect.subclass_of
expect.subclass = { of = expect.subclass_of }
expect.to_be_a_subclass_of = expect.subclass_of
expect.to_subclass = expect.subclass
