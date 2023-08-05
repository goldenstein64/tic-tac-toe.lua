local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")

math.randomseed(os.time() / math.pi)

local Computer = {}

---@param board Board
---@return integer[]
---@nodiscard
function Computer.actions(board)
	local result = {}

	for pos = 1, 9 do
		local mark = board.board[pos]
		if mark == nil then
			table.insert(result, pos)
		end
	end

	return result
end

---@param board Board
---@param mark Mark
---@param action integer
---@return Board
---@nodiscard
function Computer.resultOf(board, mark, action)
	local newBoard = Board(board)
	newBoard:setMark(action, mark)
	return newBoard
end

---@param board Board
---@return number?
---@nodiscard
function Computer.terminal(board)
	if board:won(Mark.X) then
		return 1
	elseif board:won(Mark.O) then
		return -1
	elseif board:full() then
		return 0
	end

	return nil
end

---@alias Computer.Reconciler fun(a: number, b: number): number

---@type { [Mark]: Computer.Reconciler }
Computer.reconcilers = {
	[Mark.X] = math.max,
	[Mark.O] = math.min,
}

---@type { [Mark]: number }
Computer.controls = {
	[Mark.X] = -1,
	[Mark.O] = 1,
}

---@param board Board
---@param mark Mark
---@return number
---@nodiscard
function Computer.judge(board, mark)
	local terminalValue = Computer.terminal(board)
	if terminalValue then
		return terminalValue
	end

	local value = Computer.controls[mark]
	local reconcile = Computer.reconcilers[mark]
	local newMark = mark:other()
	for _, action in ipairs(Computer.actions(board)) do
		local newBoard = Computer.resultOf(board, mark, action)
		value = reconcile(value, Computer.judge(newBoard, newMark))
	end

	return value
end

---@param board Board
---@param mark Mark
---@return number[]
---@nodiscard
function Computer.getMoves(board, mark)
	local opponentMark = mark:other()
	local moves = Computer.actions(board)

	local bestScore = Computer.controls[mark]
	local reconcile = Computer.reconcilers[mark]
	local bestMoves = {}
	for _, position in ipairs(moves) do
		local nextBoard = Computer.resultOf(board, mark, position)
		local nextScore = Computer.judge(nextBoard, opponentMark)
		if nextScore == bestScore then
			table.insert(bestMoves, position)
		elseif bestScore ~= reconcile(bestScore, nextScore) then
			bestScore = nextScore
			bestMoves = { position }
		end
	end

	return bestMoves
end

---@param board Board
---@param mark Mark
---@return number
---@nodiscard
function Computer.getMove(board, mark)
	if board:empty() then
		return math.random(9)
	else
		local moves = Computer.getMoves(board, mark)
		assert(#moves > 0, "no moves to take!")
		return moves[math.random(#moves)]
	end
end

return Computer
