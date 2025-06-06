local class = require("middleclass")

---@class tic-tac-toe.Human : middleclass.Object, tic-tac-toe.Player
---@field class tic-tac-toe.Human.Class
---@field conn tic-tac-toe.Connection
local Human = class("Human")

---@class tic-tac-toe.Human.Class : tic-tac-toe.Human, middleclass.Class
---@overload fun(conn: tic-tac-toe.Connection): tic-tac-toe.Human

---@class tic-tac-toe.Human.Err
---@field message tic-tac-toe.Message
---@field [number] any

---@protected
---@param conn tic-tac-toe.Connection
function Human:initialize(conn)
	self.conn = conn
end

---prompts the user for a move from stdin
---@param self tic-tac-toe.Human
---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number?, tic-tac-toe.Human.Err?
---@nodiscard
local function promptMove(self, board, mark)
	local posString = self.conn:prompt("human.msg.pickMove", mark)
	local pos = tonumber(posString)

	if not pos then
		return nil, { message = "human.err.NaN", posString }
	elseif pos < 1 or pos > 9 then
		return nil, { message = "human.err.outOfRange", pos }
	elseif not board:canMark(pos) then
		return nil, { message = "human.err.occupied", pos }
	else
		return pos
	end
end

---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number
---@nodiscard
function Human:getMove(board, mark)
	while true do
		local value, err = promptMove(self, board, mark)
		if value then
			return value
		elseif err then
			self.conn:print(err.message, unpack(err))
		else
			error(string.format("unknown result: (%s, %s)", tostring(value), tostring(err)))
		end
	end
end

return Human --[[@as tic-tac-toe.Human.Class]]
