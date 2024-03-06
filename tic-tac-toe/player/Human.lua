local IO = require("tic-tac-toe.IO")

---@alias Human.IOMessage
---| "msg.pickMove"
---| "err.NaN"
---| "err.outOfRange"
---| "err.occupied"

---@class Human.Error
---@field code Human.IOMessage

local ERR_NAN = { code = "err.NaN" } ---@type Human.Error
local ERR_OUT_OF_RANGE = { code = "err.outOfRange" } ---@type Human.Error
local ERR_OCCUPIED = { code = "err.occupied" } ---@type Human.Error

local ERRORS = {
	[ERR_NAN] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_OCCUPIED] = true,
}

local Human = {}

Human.io = IO({
	["msg.pickMove"] = "Pick a move, Player %s [1-9]: ",
	["err.NaN"] = "This is not a number!",
	["err.outOfRange"] = "This is not in the range of 1-9!",
	["err.occupied"] = "This space cannot be filled!",
})

---@private
---prompts the user for a move from stdin
---@param board Board
---@param mark Mark
---@return number
---@nodiscard
function Human.promptMove(board, mark)
	local posString = Human.io:prompt("msg.pickMove", mark)
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
function Human.getMove(board, mark)
	while true do
		local s, res = pcall(Human.promptMove, board, mark)
		if s then
			return res
		elseif ERRORS[res] then
			---@cast res Human.Error
			Human.io:print(res.code)
		else
			error(res)
		end
	end
end

return Human
