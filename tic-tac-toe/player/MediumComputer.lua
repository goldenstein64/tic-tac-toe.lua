local Board = require("tic-tac-toe.data.Board")

local WIN_PATTERN_LOOKUP = {
	[1] = { 1, 4, 7 },
	[2] = { 1, 5 },
	[3] = { 1, 6, 8 },
	[4] = { 2, 4 },
	[5] = { 2, 5, 7, 8 },
	[6] = { 2, 6 },
	[7] = { 3, 4, 8 },
	[8] = { 3, 5 },
	[9] = { 3, 6, 7 },
}

local MediumComputer = {}

---@param board Board
---@param mark Mark
---@return number[]?
---@nodiscard
local function getWinningMoves(board, mark)
	local markSet = {} ---@type { [number]: true? }

	for _, pattern in ipairs(Board.WIN_PATTERNS) do
		local markCount = 0
		local emptyIndex ---@type number?
		for _, pos in ipairs(pattern) do
			if board:isMarkedWith(pos, mark) then
				markCount = markCount + 1
			elseif board:canMark(pos) then
				emptyIndex = pos
			else
				break
			end
		end

		if markCount == 2 and emptyIndex then
			markSet[emptyIndex] = true
		end
	end

	local result = {}
	for pos in pairs(markSet) do
		table.insert(result, pos)
	end
	return #result > 0 and result or nil
end

---@param board Board
---@param mark Mark
---@return number[]?
---@nodiscard
local function getBlockingMoves(board, mark)
	return getWinningMoves(board, mark:other())
end

---@param board Board
---@param mark Mark
---@return number[]?
---@nodiscard
local function getTrappingMoves(board, mark)
	local result = {}
	for pos = 1, 9 do
		if not board:canMark(pos) then
			goto continue
		end

		local patternIndex = WIN_PATTERN_LOOKUP[pos]
		local trapCount = 0
		for _, i in ipairs(patternIndex) do
			local pattern = Board.WIN_PATTERNS[i]

			local hasMark = false
			local hasEmpty = false
			for _, subPos in ipairs(pattern) do
				if subPos == pos then
					goto continue2
				end

				if board:isMarkedWith(subPos, mark) then
					hasMark = true
				elseif board:canMark(subPos) then
					hasEmpty = true
				else
					goto continue2
				end
				::continue2::
			end

			if hasMark and hasEmpty then
				trapCount = trapCount + 1
			end
		end

		if trapCount > 1 then
			table.insert(result, pos)
		end
		::continue::
	end

	return #result > 0 and result or nil
end

---@param board Board
---@param mark Mark
---@return number[]?
---@nodiscard
local function getCenterMove(board, mark)
	return board:canMark(5) and { 5 } or nil
end

local CORNERS = { 1, 3, 7, 9 }

---@param board Board
---@param mark Mark
---@return number[]?
---@nodiscard
local function getCornerMoves(board, mark)
	local result = {}
	for _, pos in ipairs(CORNERS) do
		if board:canMark(pos) then
			table.insert(result, pos)
		end
	end
	return #result > 0 and result or nil
end

local SIDES = { 2, 4, 6, 8 }

---@param board Board
---@param mark Mark
---@return number[]?
---@nodiscard
local function getSideMoves(board, mark)
	local result = {}
	for _, pos in ipairs(SIDES) do
		if board:canMark(pos) then
			table.insert(result, pos)
		end
	end
	return #result > 0 and result or nil
end

---@param board Board
---@param mark Mark
---@return number
function MediumComputer.getMove(board, mark)
	local moves = getWinningMoves(board, mark)
		or getBlockingMoves(board, mark)
		or getTrappingMoves(board, mark)
		or getCenterMove(board, mark)
		or getCornerMoves(board, mark)
		or getSideMoves(board, mark)
		or error("no moves to take!")

	return moves[math.random(#moves)]
end

return MediumComputer
