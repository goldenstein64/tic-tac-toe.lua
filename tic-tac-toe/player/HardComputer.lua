local Board = require("tic-tac-toe.data.Board")
local Mark = require("tic-tac-toe.data.Mark")

---@class HardComputer : Player
local HardComputer = {}

---an enumeration of all positions in a board that are equal
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

---all the symmetries in a board
---
---- `equalities` lists what entries in the `equalities` list satisfy this
---  transformation
---
---- `image` lists how the scope of the board is limited by this symmetry
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

---returns all empty positions on the board respective to the largest matching
---symmetry
---@param board Board
---@return integer[]?
local function symmetricMoves(board)
	local equalitySet = getEqualitySet(board)
	for _, symmetry in ipairs(symmetries) do
		if symmetryMatches(equalitySet, symmetry.equalities) then
			return filterImage(board, symmetry.image)
		end
	end
end

---returns all empty positions on the board
---@param board Board
---@return integer[]
local function simpleMoves(board)
	local result = {}

	for move = 1, 9 do
		if board:canMark(move) then
			table.insert(result, move)
		end
	end

	return result
end

---returns all the valid moves a player can make. Some moves may be omitted if
---the board contains a symmetry.
---@param board Board
---@return integer[]
---@nodiscard
function HardComputer.moves(board)
	return symmetricMoves(board) or simpleMoves(board)
end

---returns a copy of `board` with `mark` applied at `move`
---@param board Board
---@param mark Mark
---@param move integer
---@return Board newBoard
---@nodiscard
function HardComputer.resultOf(board, mark, move)
	local newBoard = Board(board)
	newBoard:setMark(move, mark)
	return newBoard
end

---returns a number indicating the final result of this `board`. It will be
---`nil` if the game is not finished.
---
---- `1`: Player `X` won
---- `-1`: Player `O` won
---- `0`: there was a tie
---- `nil`: the game is not finished
---@param board Board
---@return number?
---@nodiscard
function HardComputer.terminal(board)
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
HardComputer.reconcilers = {
	[Mark.X] = math.max,
	[Mark.O] = math.min,
}

---@type { [Mark]: number }
HardComputer.controls = {
	[Mark.X] = -1,
	[Mark.O] = 1,
}

---returns a number indicating the best possible state for this `board`
---respective to `mark`
---@param board Board
---@param mark Mark
---@return number
---@nodiscard
function HardComputer.judge(board, mark)
	local terminalValue = HardComputer.terminal(board)
	if terminalValue then
		return terminalValue
	end

	local value = HardComputer.controls[mark]
	local reconcile = HardComputer.reconcilers[mark]
	local newMark = mark:other()
	for _, move in ipairs(HardComputer.moves(board)) do
		local newBoard = HardComputer.resultOf(board, mark, move)
		value = reconcile(value, HardComputer.judge(newBoard, newMark))
	end

	return value
end

---@param board Board
---@param mark Mark
---@return number[]
---@nodiscard
function HardComputer.getMoves(board, mark)
	local opponentMark = mark:other()

	local bestScore = HardComputer.controls[mark]
	local reconcile = HardComputer.reconcilers[mark]
	local bestMoves = {}
	for _, move in ipairs(simpleMoves(board)) do
		local nextBoard = HardComputer.resultOf(board, mark, move)
		local nextScore = HardComputer.judge(nextBoard, opponentMark)
		if nextScore == bestScore then
			table.insert(bestMoves, move)
		elseif bestScore ~= reconcile(bestScore, nextScore) then
			bestScore = nextScore
			bestMoves = { move }
		end
	end

	return bestMoves
end

---@param board Board
---@param mark Mark
---@return number
function HardComputer:getMove(board, mark)
	if board:empty() then
		return math.random(9)
	else
		local moves = HardComputer.getMoves(board, mark)
		assert(#moves > 0, "no moves to take!")
		return moves[math.random(#moves)]
	end
end

return HardComputer
