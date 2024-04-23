local class = require("middleclass")

---@class tic-tac-toe.Computer : middleclass.Object, tic-tac-toe.Player
---@field class tic-tac-toe.Computer.Class
local Computer = class("Computer")

---@class tic-tac-toe.Computer.Class: middleclass.Class
---@overload fun(rng: lrandom.Random): tic-tac-toe.Computer

---@param rng lrandom.Random
function Computer:initialize(rng)
	self.rng = rng
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return integer[]
function Computer:getMoves(board, mark)
	error("Computer:getMove is not implemented")
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return integer
function Computer:getMove(board, mark)
	local moves = self:getMoves(board, mark)
	assert(#moves > 0, "no moves to take!")
	return moves[self.rng:value(#moves)]
end

return Computer --[[@as tic-tac-toe.Computer.Class]]
