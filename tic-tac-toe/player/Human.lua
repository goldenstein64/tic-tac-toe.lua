local IO = require("tic-tac-toe.IO")

local ERR_NAN = { code = "err.NaN" }
local ERR_OUT_OF_RANGE = { code = "err.outOfRange" }
local ERR_OCCUPIED = { code = "err.occupied" }

local errors = {
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
		elseif errors[res] then
			Human.io:print(res.code)
		else
			error(res)
		end
	end
end

return Human
