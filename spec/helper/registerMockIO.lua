-- luacov: disable

local luassert = require("luassert")
local say = require("say")
local Object = require("tic-tac-toe.classic")

local MockIO = require("spec.io.MockIO")

---@param state table
---@param arguments any[]
---@param level integer
---@return boolean
local function print(state, arguments, level)
	local message = arguments[1] ---@type string
	local mockIO = arguments[2] ---@type MockIO
	local failure_message = arguments[3]

	if failure_message ~= nil then
		state.failure_message = failure_message
	end

	arguments[2] = mockIO.outputs

	assert(type(message) == "string", "a string must be provided for the message argument")
	assert(Object.is(mockIO, MockIO), "a MockIO object must be provided for the message argument")

	for _, output in ipairs(mockIO.outputs) do
		if output == message then
			return true
		end
	end

	return false
end

say:set(
	"assertion.print.positive",
	[[
Expected object to print a message.
Passed in:
%s
Expected one of:
%s]]
)

say:set(
	"assertion.print.negative",
	[[
Expected object not to print a message.
Passed in:
%s
Did not expect any of:
%s
]]
)

expect.map_args("print", { 2, 1, 3 })

luassert:register("assertion", "print", print, "assertion.print.positive", "assertion.print.negative")
