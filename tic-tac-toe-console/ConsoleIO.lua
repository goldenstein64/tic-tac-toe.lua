local IO = require("tic-tac-toe.IO")

local BOARD_FORMAT = [[
	 %s | %s | %s
	---|---|---
	 %s | %s | %s
	---|---|---
	 %s | %s | %s]]

---@type IO.Formatter
local function boardFormat(board)
	local strBoard = {} ---@type string[]
	for i = 1, 9 do
		strBoard[i] = tostring(board.board[i] or " ")
	end
	return BOARD_FORMAT:format(table.unpack(strBoard))
end

return IO({
	["app.msg.greeting"] = "This program runs a tic-tac-toe game.",
	["app.msg.pickPlayer"] = "Will player %s be a human or computer? [H/C]: ",
	["app.msg.pickComputer"] = "What is computer %s's difficulty? [E/M/H]: ",
	["app.msg.game"] = boardFormat,
	["app.msg.playerWon"] = "Player %s won!",
	["app.msg.tied"] = "There was a tie!",

	["app.err.invalidPlayer"] = "This does not match 'H', 'C'!",
	["app.err.invalidComputer"] = "This does not match 'E', 'M' or 'H'!",

	["human.msg.pickMove"] = "Pick a move, Player %s [1-9]: ",
	["human.err.NaN"] = "This is not a number!",
	["human.err.outOfRange"] = "This is not in the range of 1-9!",
	["human.err.occupied"] = "This space cannot be filled!",
})
