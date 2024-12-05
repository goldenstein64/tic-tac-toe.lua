local class = require("middleclass")

---@class tic-tac-toe.Mark : middleclass.Object
---@field class tic-tac-toe.Mark.Class
local Mark = class("Mark")

---@class tic-tac-toe.Mark.Class : tic-tac-toe.Mark, middleclass.Class
---@overload fun(ascii: string): tic-tac-toe.Mark
local MarkClass = Mark --[[@as tic-tac-toe.Mark.Class]]

---@protected
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
