local Object = require("classic")

---@class Mark : Object
---@field super Object
---@field ascii string
---@overload fun(ascii: string): Mark
local Mark = Object:extend()

Mark.__name = "Mark"

---@protected
---@param ascii string
function Mark:new(ascii)
	self.ascii = ascii
end

local X = Mark("X")
local O = Mark("O")

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
