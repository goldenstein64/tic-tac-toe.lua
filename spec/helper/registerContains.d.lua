---@meta

---@class luassert.internal
local luassert = {}

---assert that `array` contains an element equal to `elem`
---@param elem any
---@param array table
---@param message? string
---@return luassert.internal
function luassert.contains(elem, array, message) end

luassert.contain = luassert.contains

---@class bustez.Expectation
local expect = {}

---assert that our expectation contains an element equal to `elem`
---@param elem any
---@param message? string
---@return bustez.Expectation
function expect.contain(elem, message) end

expect.contains = expect.contain
expect.to_contain = expect.contain
