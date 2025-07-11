local class = require("middleclass")

local function reverse(array)
	for i = 1, #array / 2 do
		local j = #array - i + 1
		array[i], array[j] = array[j], array[i]
	end
end

---@class tic-tac-toe.MockConnection : middleclass.Object, tic-tac-toe.Connection
---a buffer of strings, consumed when `MockIO:prompt` is called
---@field inputs string[]
---a list of all the outputs this IO object generated
---@field outputs tic-tac-toe.MockConnection.Message[]
---@field class tic-tac-toe.MockConnection.Class
local MockIO = class("MockConnection")

---@class tic-tac-toe.MockConnection.Class : middleclass.Class
---@overload fun(inputs?: string[]): tic-tac-toe.MockConnection

---@class tic-tac-toe.MockConnection.Message
---@field message tic-tac-toe.Message
---@field [number] any

---@param inputs? string[]
function MockIO:initialize(inputs)
	if inputs then
		reverse(inputs)
		self.inputs = inputs
	else
		self.inputs = {}
	end

	self.outputs = {}
end

--[[
Sets all mocked inputs for this object. Inputs are returned one-by-one each
time `MockIO:prompt` is called.

Mocking an input `"^C"` simulates a keyboard interrupt.

Example:

```lua
local exampleIO = MockIO()

exampleIO:mockInput("first", "second", "third", "^C")

print(exampleIO:prompt("")) --> "first"
print(exampleIO:prompt("")) --> "second"
print(exampleIO:prompt("")) --> "third"
print(exampleIO:prompt("")) --> Error: Keyboard interrupt!
```
]]
---@param ... string
function MockIO:mockInput(...)
	local inputs = { ... }
	reverse(inputs)
	self.inputs = inputs
end

---clears all recorded inputs and outputs
function MockIO:mockReset()
	self.inputs = {}
	self.outputs = {}
end

---@param message tic-tac-toe.Message
---@param ... any
---@return string
function MockIO:prompt(message, ...)
	table.insert(self.outputs, { message = message, ... })

	assert(#self.inputs > 0, "input buffer exhausted!")
	local input = table.remove(self.inputs)
	assert(input ~= "^C", "Keyboard interrupt!")
	return input
end

---@param message tic-tac-toe.Message
---@param ... any
function MockIO:print(message, ...)
	table.insert(self.outputs, { message = message, ... })
end

return MockIO --[[@as tic-tac-toe.MockConnection.Class]]
