local IO = require("tic-tac-toe.IO")

local ERR_INVALID_MOVE = { code = "err.invalidMove" }
local ERR_OCCUPIED = { code = "err.occupied" }

local errors = {
	[ERR_INVALID_MOVE] = true,
	[ERR_OCCUPIED] = true,
}

local Human = {}

Human.io = IO({
	["msg.pickMove"] = "Pick a move, Player %s [1-9]: ",
	["err.invalidMove"] = "This does not match [1-9]!",
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
	assert(pos, ERR_INVALID_MOVE)
	assert(pos >= 1 and pos <= 9, ERR_INVALID_MOVE)
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
