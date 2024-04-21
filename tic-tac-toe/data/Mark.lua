local class = require("middleclass")

---@class Mark : middleclass.Object
---@field class Mark.Class
local Mark = class("Mark")

---@class Mark.Class : Mark, middleclass.Class
---@overload fun(ascii: string): Mark
local MarkClass = Mark --[[@as Mark.Class]]

---@param ascii string
function Mark:initialize(ascii)
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
	all = { X, O },
}
