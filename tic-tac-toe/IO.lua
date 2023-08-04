local Object = require("classic")

---@class IO : Object
---@field super Object
---@overload fun(messages?: { [string]: string }): IO
local IO = Object:extend()

IO.__name = "IO"

---@param messages? { [string]: string }
function IO:new(messages)
	---@type { [string]: string? }
	self.messages = {}
	if messages then
		for message, format in pairs(messages) do
			self:bind(message, format)
		end
	end
end

---@param message string
---@param format string | nil
function IO:bind(message, format)
	self.messages[message] = format
end

-- IO is mocked in the tests, this is a very simple implementation anyway.
-- luacov: disable

---@param message string
---@param ... any
function IO:format(message, ...)
	local formatter = self.messages[message] or message
	return string.format(formatter, ...)
end

---@param message string
---@param ... any
---@return string
function IO:prompt(message, ...)
	io.write(self:format(message, ...))
	return io.read()
end

---@param message string
---@param ... any
function IO:print(message, ...)
	io.write(self:format(message, ...))
	io.write("\n")
end

-- luacov: enable

return IO --[[@as IO]]
