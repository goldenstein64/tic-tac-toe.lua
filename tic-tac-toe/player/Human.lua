local class = require("middleclass")

---@class tic-tac-toe.Human.Error
---@field code tic-tac-toe.Message

local ERR_NAN = { code = "human.err.NaN" } ---@type tic-tac-toe.Human.Error
local ERR_OUT_OF_RANGE = { code = "human.err.outOfRange" } ---@type tic-tac-toe.Human.Error
local ERR_OCCUPIED = { code = "human.err.occupied" } ---@type tic-tac-toe.Human.Error

local ERRORS = {
	[ERR_NAN] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_OCCUPIED] = true,
}

---@class tic-tac-toe.Human : middleclass.Object, tic-tac-toe.Player
---@field conn tic-tac-toe.Connection
local Human = class("Human")

---@class tic-tac-toe.Human.Class : tic-tac-toe.Human, middleclass.Class
---@overload fun(conn: tic-tac-toe.Connection): tic-tac-toe.Human

---@param conn tic-tac-toe.Connection
function Human:initialize(conn)
	self.conn = conn
end

---@private
---prompts the user for a move from stdin
---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number
---@nodiscard
function Human:promptMove(board, mark)
	local posString = self.conn:prompt("human.msg.pickMove", mark)
	local pos = tonumber(posString)
	assert(pos, ERR_NAN)
	assert(pos >= 1 and pos <= 9, ERR_OUT_OF_RANGE)
	assert(board:canMark(pos), ERR_OCCUPIED)

	return pos
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number
---@nodiscard
function Human:getMove(board, mark)
	while true do
		---@type boolean, unknown
		local s, res = pcall(self.promptMove, self, board, mark)
		if s then
			---@cast res number
			return res
		elseif ERRORS[res] then
			---@cast res tic-tac-toe.Human.Error
			self.conn:print(res.code)
		else
			error(res)
		end
	end
end

return Human --[[@as tic-tac-toe.Human.Class]]
