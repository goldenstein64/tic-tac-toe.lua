local class = require("middleclass")
local Computer = require("tic-tac-toe.player.Computer")

---@class tic-tac-toe.EasyComputer : tic-tac-toe.Computer
---@field class tic-tac-toe.EasyComputer.Class
local EasyComputer = class("EasyComputer", Computer)

---@class tic-tac-toe.EasyComputer.Class : tic-tac-toe.EasyComputer, tic-tac-toe.Computer.Class
---@field super tic-tac-toe.Computer
---@overload fun(rng: lrandom.Random): tic-tac-toe.EasyComputer

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

return EasyComputer --[[@as tic-tac-toe.EasyComputer.Class]]
