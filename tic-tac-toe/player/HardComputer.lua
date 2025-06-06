local class = require("middleclass")
local Mark = require("tic-tac-toe.data.Mark")
local Computer = require("tic-tac-toe.player.Computer")

---an enumeration of all positions in a board that are equal
local EQUALITIES = {
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

local EMPTY = {}
for i = 1, 9 do
	table.insert(EMPTY, i)
end

---all the symmetries in a board
---
---- `equalities` lists what entries in the `equalities` list satisfy this
---  transformation
---
---- `image` lists how the scope of the board is limited by this symmetry
local SYMMETRIES = {
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

---@param board tic-tac-toe.Board
---@param image integer[]
---@return integer[]
local function filterImage(board, image)
	local result = {}

	for _, move in ipairs(image) do
		if board:canMark(move) then
			table.insert(result, move)
		end
	end

	return result
end

---@param board tic-tac-toe.Board
---@return { [integer]: true? }
local function getEqualitySet(board)
	local result = {}

	local data = board.data

	for i, equality in pairs(EQUALITIES) do
		result[i] = data[equality[1]] == data[equality[2]] or nil
	end

	return result
end

---returns all empty positions on the board respective to the largest matching
---symmetry
---@param board tic-tac-toe.Board
---@return integer[]?
local function symmetricMoves(board)
	local equalitySet = getEqualitySet(board)
	for _, symmetry in ipairs(SYMMETRIES) do
		if symmetryMatches(equalitySet, symmetry.equalities) then
			return filterImage(board, symmetry.image)
		end
	end
end

---returns all empty positions on the board
---@param board tic-tac-toe.Board
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

---@class tic-tac-toe.HardComputer : tic-tac-toe.Computer
---@field class tic-tac-toe.HardComputer.Class
local HardComputer = class("HardComputer", Computer)

---@class tic-tac-toe.HardComputer.Class : tic-tac-toe.HardComputer, tic-tac-toe.Computer.Class
---@field super tic-tac-toe.Computer
---@overload fun(rng: lrandom.Random): tic-tac-toe.HardComputer

---returns all the valid moves a player can make. Some moves may be omitted if
---the board contains a symmetry.
---@param board tic-tac-toe.Board
---@return integer[]
---@nodiscard
function HardComputer.moves(board)
	return symmetricMoves(board) or simpleMoves(board)
end

---returns a number indicating the final result of this `board`. It will be
---`nil` if the game is not finished.
---
---- `1`: Player `X` won
---- `-1`: Player `O` won
---- `0`: there was a tie
---- `nil`: the game is not finished
---@param board tic-tac-toe.Board
---@return -1 | 0 | 1 | nil
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

---@type { [tic-tac-toe.Mark]: Computer.Reconciler }
HardComputer.RECONCILERS = {
	[Mark.X] = math.max,
	[Mark.O] = math.min,
}

---@type { [tic-tac-toe.Mark]: number }
HardComputer.CONTROLS = {
	[Mark.X] = -1,
	[Mark.O] = 1,
}

---returns a number indicating the best possible state for this `board`
---respective to `mark`
---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number
---@nodiscard
function HardComputer.judge(board, mark)
	local terminalValue = HardComputer.terminal(board)
	if terminalValue then
		return terminalValue
	end

	local value = HardComputer.CONTROLS[mark]
	local reconcile = HardComputer.RECONCILERS[mark]
	local newMark = mark:other()
	for _, move in ipairs(HardComputer.moves(board)) do
		board:setMark(move, mark)
		value = reconcile(value, HardComputer.judge(board, newMark))
		board:setMark(move, nil)
	end

	return value
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number[]
---@nodiscard
function HardComputer:getMoves(board, mark)
	if board:empty() then
		return EMPTY
	end

	local opponentMark = mark:other()

	local bestScore = HardComputer.CONTROLS[mark]
	local reconcile = HardComputer.RECONCILERS[mark]
	local bestMoves = {}
	for _, move in ipairs(simpleMoves(board)) do
		board:setMark(move, mark)
		local nextScore = HardComputer.judge(board, opponentMark)
		board:setMark(move, nil)
		if nextScore == bestScore then
			table.insert(bestMoves, move)
		elseif bestScore ~= reconcile(bestScore, nextScore) then
			bestScore = nextScore
			bestMoves = { move }
		end
	end

	return bestMoves
end

return HardComputer --[[@as tic-tac-toe.HardComputer.Class]]
