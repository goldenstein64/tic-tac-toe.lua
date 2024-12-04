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
	["app.msg.pickPlayer"] = "Will player %s be a human or computer? [H/C]: ",
	["app.msg.pickComputer"] = "What is computer %s's difficulty? [E/M/H]: ",
	["app.msg.game"] = boardFormat,
	["app.msg.playerWon"] = "Player %s won!",
	["app.msg.tied"] = "There was a tie!",

	["app.err.invalidPlayer"] = "'%s' does not match 'H', 'C'!",
	["app.err.invalidComputer"] = "'%s' does not match 'E', 'M' or 'H'!",

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

---@overload fun(self, message: "app.msg.pickPlayer", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "app.msg.pickComputer", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "app.msg.game", board: tic-tac-toe.Board): string
---@overload fun(self, message: "app.msg.playerWon", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "app.msg.tied"): string
---@overload fun(self, message: "app.err.invalidPlayer", input: string): string
---@overload fun(self, message: "app.err.invalidComputer", input: string): string
---@overload fun(self, message: "human.msg.pickMove", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "human.err.NaN", input: string): string
---@overload fun(self, message: "human.err.outOfRange", choice: number): string
---@overload fun(self, message: "human.err.occupied", choice: number): string
function ConsoleConnection:format(message, ...)
	local formatter = self.messages[message]
	if formatter then
		return formatter(...)
	end

	return message
end

---@overload fun(self, message: "app.msg.pickPlayer", mark: tic-tac-toe.Mark)
---@overload fun(self, message: "app.msg.pickComputer", mark: tic-tac-toe.Mark)
---@overload fun(self, message: "app.msg.game", board: tic-tac-toe.Board)
---@overload fun(self, message: "app.msg.playerWon", mark: tic-tac-toe.Mark)
---@overload fun(self, message: "app.msg.tied")
---@overload fun(self, message: "app.err.invalidPlayer", input: string)
---@overload fun(self, message: "app.err.invalidComputer", input: string)
---@overload fun(self, message: "human.msg.pickMove", mark: tic-tac-toe.Mark)
---@overload fun(self, message: "human.err.NaN", input: string)
---@overload fun(self, message: "human.err.outOfRange", choice: number)
---@overload fun(self, message: "human.err.occupied", choice: number)
function ConsoleConnection:print(message, ...)
	self.outFile:write(self:format(message, ...))
	self.outFile:write("\n")
end

---@overload fun(self, message: "app.msg.pickPlayer", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "app.msg.pickComputer", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "app.msg.game", board: tic-tac-toe.Board): string
---@overload fun(self, message: "app.msg.playerWon", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "app.msg.tied"): string
---@overload fun(self, message: "app.err.invalidPlayer", input: string): string
---@overload fun(self, message: "app.err.invalidComputer", input: string): string
---@overload fun(self, message: "human.msg.pickMove", mark: tic-tac-toe.Mark): string
---@overload fun(self, message: "human.err.NaN", input: string): string
---@overload fun(self, message: "human.err.outOfRange", choice: number): string
---@overload fun(self, message: "human.err.occupied", choice: number): string
function ConsoleConnection:prompt(message, ...)
	self.outFile:write(self:format(message, ...))
	return self.inFile:read()
end

return ConsoleConnectionClass
