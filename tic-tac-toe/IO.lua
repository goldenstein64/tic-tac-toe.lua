local class = require("middleclass")

---@alias IO.Formatter fun(...: any): string

---@class IO : middleclass.Object
---@field class IO.Class
local IO = class("IO")

---@class IO.Class : IO, middleclass.Class
---@overload fun(messages?: { [Message]: IO.Formatter | string }): IO

---@param messages? { [Message]: IO.Formatter | string }
function IO:initialize(messages)
	---@type { [Message]: IO.Formatter }
	self.messages = {}
	if messages then
		for message, format in pairs(messages) do
			self:bind(message, format)
		end
	end
end

---@param message string
---@param formatter IO.Formatter | string?
function IO:bind(message, formatter)
	local type_formatter = type(formatter)
	if type_formatter == "string" then
		self.messages[message] = function(...)
			return string.format(formatter, ...)
		end
	elseif type_formatter == "function" then
		self.messages[message] = formatter
	else
		error("unknown formatter type")
	end
end

-- IO is mocked in the tests, this is a very simple implementation anyway.
-- luacov: disable

---@param message Message
---@param ... any
function IO:format(message, ...)
	local formatter = self.messages[message]
	if formatter then
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

return IO --[[@as IO.Class]]
