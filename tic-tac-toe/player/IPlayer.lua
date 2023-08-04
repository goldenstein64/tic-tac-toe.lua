local Object = require("classic")

---@class Player : Object
---@field super Object
---@field board Board
---@field mark Mark
---@overload fun(game: Board, mark: Mark): Player
local IPlayer = Object:extend()

IPlayer.__name = "Player"

---@protected
---@param board Board
---@param mark Mark
function IPlayer:new(board, mark)
	assert(getmetatable(self) ~= IPlayer, "attempt to instantiate interface IPlayer")

	self.board = board
	self.mark = mark
end

---gives a position 1-9 on the game board
---@return number
function IPlayer:getMove()
	error("getMove() not implemented!")
end

return IPlayer --[[@as Player]]
