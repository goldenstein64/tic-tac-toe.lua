local Object = require("classic")

---@alias IO.Formatter fun(...: any): string

---@class IO : Object
---@field super Object
local IO = Object:extend()

---@class IO.Class
---@overload fun(messages?: { [Message]: IO.Formatter | string }): IO
local IOClass = IO --[[@as IO.Class]]

IO.__name = "IO"

---@param messages? { [Message]: IO.Formatter | string }
function IO:new(messages)
	---@type { [Message]: IO.Formatter | string? }
	self.messages = {}
	if messages then
		for message, format in pairs(messages) do
			self:bind(message, format)
		end
	end
end

---@param message string
---@param format IO.Formatter | string?
function IO:bind(message, format)
	self.messages[message] = format
end

-- IO is mocked in the tests, this is a very simple implementation anyway.
-- luacov: disable

---@param message Message
---@param ... any
function IO:format(message, ...)
	local formatter = self.messages[message]
	local type_formatter = type(formatter)
	if type_formatter == "string" then
		return formatter:format(...)
	elseif type_formatter == "function" then
		return formatter(...)
	end
	return message
end

---@param message Message
---@param ... any
---@return string
function IO:prompt(message, ...)
	io.write(self:format(message, ...))
	return io.read()
end

---@param message Message
---@param ... any
function IO:print(message, ...)
	io.write(self:format(message, ...))
	io.write("\n")
end

-- luacov: enable

return IOClass
