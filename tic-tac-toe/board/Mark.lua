local Object = require("classic")

---@class Mark : Object
---@field super Object
local Mark = Object:extend()

---@class Mark.Class
---@overload fun(ascii: string): Mark
local MarkClass = Mark --[[@as Mark.Class]]

Mark.__name = "Mark"

---@protected
---@param ascii string
function Mark:new(ascii)
	Mark.super.new(self)
	self.ascii = ascii
end

local X = MarkClass("X")
local O = MarkClass("O")

local other = {
	[X] = O,
	[O] = X,
}

function Mark:other()
	return other[self] or error("Unknown mark!")
end

function Mark:__tostring()
	return self.ascii
end

return {
	X = X,
	O = O,
}
