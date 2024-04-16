local Object = require("classic")

local Mark = require("tic-tac-toe.board.Mark")

local BOARD_FORMAT = [[
 %s | %s | %s
---|---|---
 %s | %s | %s
---|---|---
 %s | %s | %s]]

---@class Board : Object
---@field super Object
local Board = Object:extend()

---@class Board.Class
---@overload fun(board: Board?): Board
local BoardClass = Board --[[@as Board.Class]]

Board.__name = "Board"

---@protected
---@param board Board?
function Board:new(board)
	---@type (Mark?)[]
	self.board = {}

	if board then
		for i = 1, 9 do
			self.board[i] = board.board[i]
		end
	end
end

---@param pattern string
---@return Board
function BoardClass.fromPattern(pattern)
	local result = BoardClass()
	for i = 1, 9 do
		local char = pattern:sub(i, i)
		local mark = Mark[char]
		result:setMark(i, mark)
	end
	return result
end

---@type number[][]
BoardClass.WIN_PATTERNS = {
	[1] = { 1, 2, 3 },
	[2] = { 4, 5, 6 },
	[3] = { 7, 8, 9 },
	[4] = { 1, 4, 7 },
	[5] = { 2, 5, 8 },
	[6] = { 3, 6, 9 },
	[7] = { 1, 5, 9 },
	[8] = { 3, 5, 7 },
}

---attempt to mark the given position with the given mark. Errors if it is
---unable to do so
---@param position number
---@param mark Mark?
function Board:setMark(position, mark)
	assert(self:canMark(position), "This space is already filled!")

	self.board[position] = mark
end

---can this position on the board be marked?
---@param position number
---@return boolean
function Board:canMark(position)
	return self:isMarkedWith(position, nil)
end

---does this position on the board have this mark?
---@param position number
---@param mark Mark?
---@return boolean
function Board:isMarkedWith(position, mark)
	return position >= 1 and position <= 9 and self.board[position] == mark
end

---did the player with this mark win?
---@param mark Mark
---@return boolean
function Board:won(mark)
	for _, pattern in ipairs(BoardClass.WIN_PATTERNS) do
		local isWon = true
		for _, position in ipairs(pattern) do
			if self.board[position] ~= mark then
				isWon = false
				break
			end
		end

		if isWon then
			return true
		end
	end

	return false
end

---are there no more places on the board to mark?
---@return boolean
function Board:full()
	for i = 1, 9 do
		local mark = self.board[i]
		if mark == nil then
			return false
		end
	end

	return true
end

---are there any marks on the board?
---@return boolean
function Board:empty()
	for i = 1, 9 do
		local mark = self.board[i]
		if mark ~= nil then
			return false
		end
	end

	return true
end

---@return string
function Board:__tostring()
	-- luacov: disable
	local strBoard = {}

	for i = 1, 9 do
		strBoard[i] = tostring(self.board[i] or " ")
	end

	return BOARD_FORMAT:format(table.unpack(strBoard))
	-- luavoc: enable
end

return BoardClass --[[@as Board.Class]]
