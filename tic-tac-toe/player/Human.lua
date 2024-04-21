local Object = require("classic")
local IO = require("tic-tac-toe.IO")

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
---@overload fun(): Human
local HumanClass = Human --[[@as Human.Class]]

Human.io = IO({
	["human.msg.pickMove"] = "Pick a move, Player %s [1-9]: ",
	["human.err.NaN"] = "This is not a number!",
	["human.err.outOfRange"] = "This is not in the range of 1-9!",
	["human.err.occupied"] = "This space cannot be filled!",
})

---@private
---prompts the user for a move from stdin
---@param board Board
---@param mark Mark
---@return number
---@nodiscard
function Human:promptMove(board, mark)
	local posString = Human.io:prompt("human.msg.pickMove", mark)
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
			Human.io:print(res.code)
		else
			error(res)
		end
	end
end

return HumanClass
