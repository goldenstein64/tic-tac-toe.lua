---@class tic-tac-toe.EasyComputer : tic-tac-toe.Player
local EasyComputer = {}

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number[]
---@nodiscard
function EasyComputer.getMoves(board, mark)
	---@type number[]
	local result = {}

	for pos = 1, 9 do
		if board:canMark(pos) then
			table.insert(result, pos)
		end
	end

	return result
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number
function EasyComputer:getMove(board, mark)
	local moves = EasyComputer.getMoves(board, mark)
	assert(#moves > 0, "no moves to take!")
	return moves[math.random(#moves)]
end

return EasyComputer
