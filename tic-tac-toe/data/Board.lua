local class = require("middleclass")

local Mark = require("tic-tac-toe.data.Mark")

---@class tic-tac-toe.Board : middleclass.Object
---@field class tic-tac-toe.Board.Class
---@field data (tic-tac-toe.Mark?)[]
local Board = class("Board")

---@class tic-tac-toe.Board.Class : tic-tac-toe.Board, middleclass.Class
---@overload fun(board: tic-tac-toe.Board?): tic-tac-toe.Board
local BoardClass = Board.static --[[@as tic-tac-toe.Board.Class]]

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

---@protected
---@param board tic-tac-toe.Board?
function Board:initialize(board)
	---@type (tic-tac-toe.Mark?)[]
	self.data = {}

	if board then
		for i = 1, 9 do
			self.data[i] = board.data[i]
		end
	end
end

---@param pattern string
---@return tic-tac-toe.Board
function BoardClass.fromPattern(pattern)
	local result = Board() --[[@as tic-tac-toe.Board]]
	for i = 1, 9 do
		local char = pattern:sub(i, i)
		local mark = Mark[char]
		result:setMark(i, mark)
	end
	return result
end

---attempt to mark the given position with the given mark. Errors if it is
---unable to do so
---@param position number
---@param mark tic-tac-toe.Mark?
function Board:setMark(position, mark)
	assert(self:canMark(position) or mark == nil, "This space is already filled!")

	self.data[position] = mark
end

---can this position on the board be marked?
---@param position number
---@return boolean
function Board:canMark(position)
	return self:isMarkedWith(position, nil)
end

---does this position on the board have this mark?
---@param position number
---@param mark tic-tac-toe.Mark?
---@return boolean
function Board:isMarkedWith(position, mark)
	return position >= 1 and position <= 9 and self.data[position] == mark
end

---did the player with this mark win?
---@param mark tic-tac-toe.Mark
---@return boolean
function Board:won(mark)
	for _, pattern in ipairs(BoardClass.WIN_PATTERNS) do
		local isWon = true
		for _, position in ipairs(pattern) do
			if self.data[position] ~= mark then
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
		local mark = self.data[i]
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
		local mark = self.data[i]
		if mark ~= nil then
			return false
		end
	end

	return true
end

---@return string
function Board:__tostring()
	local strBoard = {}
	for i = 1, 9 do
		strBoard[i] = tostring(self.data[i] or "`")
	end

	return table.concat(strBoard)
end

return Board --[[@as tic-tac-toe.Board.Class]]
