local IO = require("tic-tac-toe.IO")

---@class MockIO : IO
---@field class MockIO.Class
local MockIO = IO:subclass("MockIO") --[[@as MockIO]]

---@class MockIO.Class : MockIO, IO.Class
---@field super IO.Class
---@overload fun(): MockIO

function MockIO:initialize()
	---a buffer of strings, consumed when `MockIO:prompt` is called
	---@type string[]
	self.inputs = {}

	---a list of all the outputs this IO object generated
	---@type string[]
	self.outputs = {}
end

--[[
Sets all mocked inputs for this object. Inputs are returned one-by-one each
time `MockIO:prompt` is called.

Mocking an input `"^C"` simulates a keyboard interrupt.

Example:

```lua
local exampleIO = MockIO()

exampleIO:mockInput("first", "second", "third")

print(exampleIO:prompt("")) --> "first"
print(exampleIO:prompt("")) --> "second"
print(exampleIO:prompt("")) --> "third"
```
]]
---@param ... string
function MockIO:mockInput(...)
	self.inputs = { ... }
end

---clears all recorded inputs and outputs
function MockIO:mockReset()
	self.inputs = {}
	self.outputs = {}
end

---@param message string
---@param ... any
---@return string
function MockIO:prompt(message, ...)
	table.insert(self.outputs, message)

	assert(#self.inputs > 0, "input buffer exhausted!")
	local input = table.remove(self.inputs, 1)
	assert(input ~= "^C", "Keyboard interrupt!")
	return input
end

---@param message string
---@param ... any
function MockIO:print(message, ...)
	table.insert(self.outputs, message)
end

return MockIO --[[@as MockIO.Class]]
