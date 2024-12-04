local class = require("middleclass")
local unpack = table.unpack or unpack

---@alias tic-tac-toe.ConsoleConnection.Formatter fun(...: any): string

local BOARD_FORMAT = [[
 %s | %s | %s
---|---|---
 %s | %s | %s
---|---|---
 %s | %s | %s]]

---@param board tic-tac-toe.Board
---@return string
local function boardFormat(board)
	local strBoard = {} ---@type string[]
	for i = 1, 9 do
		strBoard[i] = tostring(board.data[i] or " ")
	end
	return BOARD_FORMAT:format(unpack(strBoard))
end

local messages = {
	["app.msg.greeting"] = "This program runs a tic-tac-toe game.",
	["app.msg.pickPlayer"] = "Will player %s be a human or computer? [H/C]: ",
	["app.msg.pickComputer"] = "What is computer %s's difficulty? [E/M/H]: ",
	["app.msg.game"] = boardFormat,
	["app.msg.playerWon"] = "Player %s won!",
	["app.msg.tied"] = "There was a tie!",

	["app.err.invalidPlayer"] = "This does not match 'H', 'C'!",
	["app.err.invalidComputer"] = "This does not match 'E', 'M' or 'H'!",

	["human.msg.pickMove"] = "Pick a move, Player %s [1-9]: ",
	["human.err.NaN"] = "'%s' is not a valid number!",
	["human.err.outOfRange"] = "Slot %d is not in the range of 1-9!",
	["human.err.occupied"] = "Slot %d is occupied!",
}

for msg, formatter in pairs(messages) do
	if type(formatter) == "string" then
		messages[msg] = function(...)
			return string.format(formatter, ...)
		end
	end
end
---@cast messages { [tic-tac-toe.Message]: tic-tac-toe.ConsoleConnection.Formatter }

---@class tic-tac-toe.ConsoleConnection : middleclass.Object, tic-tac-toe.Connection
---@field class tic-tac-toe.ConsoleConnection.Class
---@field messages { [tic-tac-toe.Message]: tic-tac-toe.ConsoleConnection.Formatter }
---@field inFile file*
---@field outFile file*
local ConsoleConnection = class("ConsoleConnection")

---@class tic-tac-toe.ConsoleConnection.Class : tic-tac-toe.ConsoleConnection, middleclass.Class
---@overload fun(inFile?: file*, outFile?: file*): tic-tac-toe.ConsoleConnection
local ConsoleConnectionClass = ConsoleConnection --[[@as tic-tac-toe.ConsoleConnection.Class]]

---@param inFile? file*
---@param outFile? file*
function ConsoleConnection:initialize(inFile, outFile)
	self.messages = messages
	self.inFile = inFile or io.stdin
	self.outFile = outFile or io.stdout
end

---@param message tic-tac-toe.Message
---@param ... any
---@return string
function ConsoleConnection:format(message, ...)
	local formatter = self.messages[message]
	if formatter then
		return formatter(...)
	end

	return message
end

---@param message tic-tac-toe.Message
---@param ... any
function ConsoleConnection:print(message, ...)
	self.outFile:write(self:format(message, ...))
	self.outFile:write("\n")
end

---@param message tic-tac-toe.Message
---@param ... any
function ConsoleConnection:prompt(message, ...)
	self.outFile:write(self:format(message, ...))
	return self.inFile:read()
end

return ConsoleConnectionClass
