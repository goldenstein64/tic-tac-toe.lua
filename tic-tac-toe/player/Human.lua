local IPlayer = require("tic-tac-toe.player.IPlayer")
local IO = require("tic-tac-toe.IO")

local ERR_INVALID_MOVE = { code = "err.invalidMove" }
local ERR_OCCUPIED = { code = "err.occupied" }

local errors = {
	[ERR_INVALID_MOVE] = true,
	[ERR_OCCUPIED] = true,
}

---@class Human : Player
---@field super Player
---@overload fun(game: Board, mark: Mark): Human
local Human = IPlayer:extend()

Human.__name = "Human"

Human.io = IO({
	["msg.pickMove"] = "Pick a move, Player %s [1-9]: ",
	["err.invalidMove"] = "This does not match [1-9]!",
	["err.occupied"] = "This space cannot be filled!",
})

---@private
---prompts the user for a move from stdin
---@return number
function Human:promptMove()
	local posString = self.io:prompt("msg.pickMove", self.mark)
	local pos = tonumber(posString)
	assert(pos, ERR_INVALID_MOVE)
	assert(pos >= 1 and pos <= 9, ERR_INVALID_MOVE)
	assert(self.board:canMark(pos), ERR_OCCUPIED)

	return pos
end

function Human:getMove()
	while true do
		local s, res = pcall(self.promptMove, self)
		if s then
			return res
		elseif errors[res] then
			self.io:print(res.code)
		else
			error(res)
		end
	end
end

return Human --[[@as Human]]
