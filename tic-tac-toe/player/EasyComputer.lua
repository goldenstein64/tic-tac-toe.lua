local class = require("middleclass")

---@class tic-tac-toe.EasyComputer : middleclass.Object, tic-tac-toe.Player
---@field class tic-tac-toe.EasyComputer.Class
local EasyComputer = class("EasyComputer")

---@class tic-tac-toe.EasyComputer.Class : tic-tac-toe.EasyComputer, middleclass.Class
---@overload fun(rng: lrandom.Random): tic-tac-toe.EasyComputer
local EasyComputerClass = EasyComputer.static --[[@as tic-tac-toe.EasyComputer.Class]]

---@param rng lrandom.Random
function EasyComputer:initialize(rng)
	self.rng = rng
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number[]
---@nodiscard
function EasyComputer:getMoves(board, mark)
	---@type number[]
	local result = {}

	for move = 1, 9 do
		if board:canMark(move) then
			table.insert(result, move)
		end
	end

	return result
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number
function EasyComputer:getMove(board, mark)
	local moves = self:getMoves(board, mark)
	assert(#moves > 0, "no moves to take!")
	return moves[self.rng:value(#moves)]
end

return EasyComputer --[[@as tic-tac-toe.EasyComputer.Class]]
