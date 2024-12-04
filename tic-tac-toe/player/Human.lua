local class = require("middleclass")

---@class tic-tac-toe.Human : middleclass.Object, tic-tac-toe.Player
---@field conn tic-tac-toe.Connection
local Human = class("Human")

---@class tic-tac-toe.Human.Class : tic-tac-toe.Human, middleclass.Class
---@overload fun(conn: tic-tac-toe.Connection): tic-tac-toe.Human

---@class tic-tac-toe.Human.Err
---@field code tic-tac-toe.Message
---@field [number] any

---@param conn tic-tac-toe.Connection
function Human:initialize(conn)
	self.conn = conn
end

---@private
---prompts the user for a move from stdin
---@param board tic-tac-toe.Board
---@param mark tic-tac-toe.Mark
---@return number?, tic-tac-toe.Human.Err?
---@nodiscard
function Human:promptMove(board, mark)
	local posString = self.conn:prompt("human.msg.pickMove", mark)
	local pos = tonumber(posString)

	if not pos then
		return nil, { code = "human.err.NaN", posString }
	elseif pos < 1 or pos > 9 then
		return nil, { code = "human.err.outOfRange", pos }
	elseif not board:canMark(pos) then
		return nil, { code = "human.err.occupied", pos }
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
		local value, err = self:promptMove(board, mark)
		if value then
			return value
		elseif err then
			self.conn:print(err.code, unpack(err))
		else
			error(string.format("unknown result: (%s, %s)", tostring(value), tostring(err)))
		end
	end
end

return Human --[[@as tic-tac-toe.Human.Class]]
