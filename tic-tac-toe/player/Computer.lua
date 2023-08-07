local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")

math.randomseed(os.time() / math.pi)

local Computer = {}

local symmetryPriority = {
	"rotate90",
	"rotate180",
	"diagonalDown",
	"diagonalUp",
	"horizontal",
	"vertical",
}

---@type number[][][]
local symmetries = {
	vertical = {
		{ 1, 3 },
		{ 4, 6 },
		{ 7, 9 },
	},
	horizontal = {
		{ 1, 7 },
		{ 2, 8 },
		{ 3, 9 },
	},
	diagonalUp = {
		{ 2, 4 },
		{ 3, 7 },
		{ 6, 8 },
	},
	diagonalDown = {
		{ 1, 9 },
		{ 2, 6 },
		{ 4, 8 },
	},
	rotate180 = {
		{ 1, 9 },
		{ 2, 8 },
		{ 3, 7 },
		{ 4, 6 },
	},
	rotate90 = {
		{ 1, 3, 7, 9 },
		{ 2, 4, 6, 8 },
	},
}

local symmetryImages = {
	vertical = { 1, 2, 4, 5, 7, 8 },
	horizontal = { 1, 2, 3, 4, 5, 6 },
	diagonalUp = { 1, 2, 3, 4, 5, 7 },
	diagonalDown = { 1, 2, 3, 5, 6, 9 },
	rotate180 = { 1, 2, 3, 4, 5 },
	rotate90 = { 1, 2, 5 },
}

---@param board Board
---@param symmetry number[][]
---@return boolean
local function symmetryMatches(board, symmetry)
	for _, matches in ipairs(symmetry) do
		local firstMark = board.board[matches[1]]
		for i = 2, #matches do
			if firstMark ~= board.board[matches[i]] then
				return false
			end
		end
	end

	return true
end

---@param board Board
---@return integer[]
local function filterMarkableActions(board, ...)
	local result = {}

	for _, pos in ... do
		if board:canMark(pos) then
			table.insert(result, pos)
		end
	end

	return result
end

---@param board Board
---@return integer[]
local function simpleActions(board)
	local result = {}

	for pos = 1, 9 do
		if board:canMark(pos) then
			table.insert(result, pos)
		end
	end

	return result
end

---@param board Board
---@return integer[]?
local function symmetricActions(board)
	for _, symmetryName in ipairs(symmetryPriority) do
		if symmetryMatches(board, symmetries[symmetryName]) then
			return filterMarkableActions(board, ipairs(symmetryImages[symmetryName]))
		end
	end
end

---@param board Board
---@return integer[]
---@nodiscard
function Computer.actions(board)
	return symmetricActions(board) or simpleActions(board)
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

	local bestScore = Computer.controls[mark]
	local reconcile = Computer.reconcilers[mark]
	local bestMoves = {}
	for _, position in ipairs(simpleActions(board)) do
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
