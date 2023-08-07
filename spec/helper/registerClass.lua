-- luacov: disable

local expect = require("bustez.expect")
local luassert = require("luassert")
local say = require("say")
local Object = require("classic")

say:set(
	"assertion.instance_of.negative",
	[[
Expected object to not be an instance of a class.
Passed in:
%s
Did not expect an instance of:
%s]]
)

say:set(
	"assertion.instance_of.positive",
	[[
Expected object to be an instance of a class.
Passed in instance:
%s
Expected an instance of:
%s]]
)

local function instance_of(state, arguments, level)
	local base_class = arguments[1]
	local instance = arguments[2]
	local failure_message = arguments[3]
	if failure_message ~= nil then
		state.failure_message = failure_message
	end

	assert(type(base_class) == "table", "bad 'baseClass' argument, not a table.")
	assert(Object.is(base_class, Object), "bad 'baseClass' argument, not a table.")
	assert(type(instance) == "table", "bad 'instance' argument, not a table.")
	assert(Object.is(instance, Object), "bad 'instance' argument, not a table.")

	-- formatting arguments
	arguments[1] = instance.__name or tostring(instance)
	arguments[2] = base_class.__name or tostring(base_class)

	return Object.is(instance, base_class)
end

luassert:register(
	"assertion",
	"instance_of",
	instance_of,
	"assertion.instance_of.positive",
	"assertion.instance_of.negative"
)

luassert:register(
	"assertion",
	"instance",
	instance_of,
	"assertion.instance_of.positive",
	"assertion.instance_of.negative"
)

say:set(
	"assertion.subclass_of.negative",
	[[
Expected object to be a subclass of a class.
Passed in:
%s
Expected a subclass of:
%s
]]
)

say:set(
	"assertion.subclass_of.positive",
	[[
Expected object not to be a subclass of a class.
Passed in:
%s
Did not expect a subclass of:
%s
]]
)

luassert:register(
	"assertion",
	"subclass_of",
	instance_of,
	"assertion.subclass_of.positive",
	"assertion.subclass_of.negative"
)

luassert:register(
	"assertion",
	"subclass",
	instance_of,
	"assertion.subclass_of.positive",
	"assertion.subclass_of.negative"
)

expect.map_args("instance_of", { 2, 1, 3 })
expect.map_args("instance", { 2, 1, 3 })
expect.map_args("subclass_of", { 2, 1, 3 })
expect.map_args("subclass", { 2, 1, 3 })
