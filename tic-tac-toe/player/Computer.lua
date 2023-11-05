local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")

math.randomseed(os.time() / math.pi)

local Computer = {}

local equalities = {
	[1] = { 1, 3 },
	[2] = { 4, 6 },
	[3] = { 7, 9 },
	[4] = { 1, 7 },
	[5] = { 2, 8 },
	[6] = { 3, 9 },
	[7] = { 2, 4 },
	[8] = { 3, 7 },
	[9] = { 6, 8 },
	[10] = { 4, 8 },
	[11] = { 1, 9 },
	[12] = { 2, 6 },
}

local symmetries = {
	{ -- rotate 90
		equalities = { 1, 2, 3, 7, 8, 9 },
		image = { 1, 2, 5 },
	},
	{ -- rotate 180
		equalities = { 2, 5, 8, 11 },
		image = { 1, 2, 3, 4, 5 },
	},
	{ -- vertical
		equalities = { 1, 2, 3 },
		image = { 1, 2, 4, 5, 7, 8 },
	},
	{ -- horizontal
		equalities = { 4, 5, 6 },
		image = { 1, 2, 3, 4, 5, 6 },
	},
	{ -- diagonal down
		equalities = { 7, 8, 9 },
		image = { 1, 2, 3, 4, 5, 7 },
	},
	{ -- diagonal up
		equalities = { 10, 11, 12 },
		image = { 1, 2, 3, 5, 6, 9 },
	},
}

---@param equalSet { [number]: true? }
---@param symmetry number[]
---@return boolean
local function symmetryMatches(equalSet, symmetry)
	for _, index in ipairs(symmetry) do
		if not equalSet[index] then
			return false
		end
	end

	return true
end

---@param board Board
---@param image integer[]
---@return integer[]
local function filterImage(board, image)
	local result = {}

	for _, pos in ipairs(image) do
		if board:canMark(pos) then
			table.insert(result, pos)
		end
	end

	return result
end

---@param board Board
---@return { [integer]: true? }
local function getEqualitySet(board)
	local result = {}

	local data = board.board

	for i, equality in pairs(equalities) do
		result[i] = data[equality[1]] == data[equality[2]]
	end

	return result
end

---@param board Board
---@return integer[]?
local function symmetricActions(board)
	local equalitySet = getEqualitySet(board)
	for _, symmetry in ipairs(symmetries) do
		if symmetryMatches(equalitySet, symmetry.equalities) then
			return filterImage(board, symmetry.image)
		end
	end
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
