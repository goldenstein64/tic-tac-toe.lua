-- luacov: disable

local expect = require("bustez.expect")
local luassert = require("luassert")
local say = require("say")

say:set(
	"assertion.contains.negative",
	[[
Expected array not to contain element.
Passed in:
%s
Did not expect to contain:
%s]]
)

say:set(
	"assertion.contains.positive",
	[[
Expected array to contain element.
Passed in:
%s
Expected to contain:
%s]]
)

local function contains(state, arguments, level)
	local expected_elem = arguments[1]
	local array = arguments[2]
	local failure_message = arguments[3]
	if failure_message ~= nil then
		state.failure_message = failure_message
	end

	assert(type(array) == "table", "bad 'array' argument, not a table.")

	-- formatting arguments
	arguments[1], arguments[2] = arguments[2], arguments[1]

	for _, elem in ipairs(array) do
		if elem == expected_elem then
			return true
		end
	end

	return false
end

luassert:register("assertion", "contains", contains, "assertion.contains.positive", "assertion.contains.negative")
luassert:register("assertion", "contain", contains, "assertion.contains.positive", "assertion.contains.negative")

expect.map_args("contains", { 2, 1, 3 })
expect.map_args("contain", { 2, 1, 3 })
