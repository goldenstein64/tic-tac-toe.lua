local Object = require("classic")

---@class Human.Error
---@field code Message

local ERR_NAN = { code = "human.err.NaN" } ---@type Human.Error
local ERR_OUT_OF_RANGE = { code = "human.err.outOfRange" } ---@type Human.Error
local ERR_OCCUPIED = { code = "human.err.occupied" } ---@type Human.Error

local ERRORS = {
	[ERR_NAN] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_OCCUPIED] = true,
}

---@class Human : Object, Player
---@field super Object
local Human = Object:extend()

---@class Human.Class
---@overload fun(io: IO): Human
local HumanClass = Human --[[@as Human.Class]]

---@param io IO
function Human:new(io)
	self.io = io
end

---@private
---prompts the user for a move from stdin
---@param board Board
---@param mark Mark
---@return number
---@nodiscard
function Human:promptMove(board, mark)
	local posString = self.io:prompt("human.msg.pickMove", mark)
	local pos = tonumber(posString)
	assert(pos, ERR_NAN)
	assert(pos >= 1 and pos <= 9, ERR_OUT_OF_RANGE)
	assert(board:canMark(pos), ERR_OCCUPIED)

	return pos
end

---@param board Board
---@param mark Mark
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
			---@cast res Human.Error
			self.io:print(res.code)
		else
			error(res)
		end
	end
end

return HumanClass
