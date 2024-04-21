local class = require("middleclass")

---@alias IO.Formatter fun(...: any): string

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

local ioMap = {
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
}

for msg, formatter in pairs(ioMap) do
	if type(formatter) == "string" then
		ioMap[msg] = function(...)
			return string.format(formatter, ...)
		end
	end
end
---@cast ioMap { [Message]: IO.Formatter }

---@class ConsoleConnection : middleclass.Object, Connection
---@field class ConsoleConnection.Class
local ConsoleConnection = class("ConsoleConnection")

---@class ConsoleConnection.Class : ConsoleConnection, middleclass.Class
---@overload fun(): ConsoleConnection
local ConsoleConnectionClass = ConsoleConnection.static --[[@as ConsoleConnection.Class]]

---@param inFile? file*
---@param outFile? file*
function ConsoleConnection:initialize(inFile, outFile)
	self.inFile = inFile or io.stdin
	self.outFile = outFile or io.stdout
end

---@param message Message
---@param ... any
---@return string
function ConsoleConnection:format(message, ...)
	local formatter = ioMap[message]
	if formatter then
		return formatter(...)
	end

	return message
end

---@param message Message
---@param ... any
function ConsoleConnection:print(message, ...)
	self.outFile:write(self:format(message, ...))
	self.outFile:write("\n")
end

---@param message Message
---@param ... any
function ConsoleConnection:prompt(message, ...)
	self.outFile:write(self:format(message, ...))
	return self.inFile:read()
end

return ConsoleConnection --[[@as ConsoleConnection.Class]]
