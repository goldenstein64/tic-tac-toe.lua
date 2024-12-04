local class = require("middleclass")
local random = require("random")

local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")
local Human = require("tic-tac-toe.player.Human")
local Board = require("tic-tac-toe.data.Board")
local Mark = require("tic-tac-toe.data.Mark")

---@class tic-tac-toe.Player
---@field getMove fun(self: any, board: tic-tac-toe.Board, mark: tic-tac-toe.Mark): integer

---@class tic-tac-toe.App : middleclass.Object
---@field class tic-tac-toe.App.Class
---@field conn tic-tac-toe.Connection
---@field board tic-tac-toe.Board
local App = class("App")

---@class tic-tac-toe.App.Class : tic-tac-toe.App, middleclass.Class
---@overload fun(conn: tic-tac-toe.Connection, pattern?: string): tic-tac-toe.App
local AppClass = App --[[@as tic-tac-toe.App.Class]]

---@param conn tic-tac-toe.Connection
---@param pattern? string
function App:initialize(conn, pattern)
	self.conn = conn
	self.board = pattern and Board.fromPattern(pattern) or Board()
end

---@param mark tic-tac-toe.Mark
---@return tic-tac-toe.Player?
function App:promptComputerOnce(mark)
	local chosenComputer = self.conn:prompt("app.msg.pickComputer", mark)
	if chosenComputer == "E" then
		return EasyComputer(random.new())
	elseif chosenComputer == "M" then
		return MediumComputer(random.new())
	elseif chosenComputer == "H" then
		return HardComputer(random.new())
	else
		self.conn:print("app.err.invalidComputer")
		return nil
	end
end

---@param mark tic-tac-toe.Mark
---@return tic-tac-toe.Player?
function App:promptPlayerOnce(mark)
	local chosenPlayer = self.conn:prompt("app.msg.pickPlayer", mark)
	if chosenPlayer == "H" then
		return Human(self.conn)
	elseif chosenPlayer == "C" then
		return self:promptComputerOnce(mark)
	else
		self.conn:print("app.err.invalidPlayer")
		return nil
	end
end

---@param mark tic-tac-toe.Mark
---@return tic-tac-toe.Player
function App:promptPlayer(mark)
	local player ---@type tic-tac-toe.Player?
	repeat
		player = self:promptPlayerOnce(mark)
	until player
	---@cast player tic-tac-toe.Player
	return player
end

---@return tic-tac-toe.Player[])
function App:choosePlayers()
	---@type tic-tac-toe.Player[]
	local players = {}
	for i, mark in ipairs(Mark.all) do
		players[i] = self:promptPlayer(mark)
	end

	return players
end

---@param players tic-tac-toe.Player[]
---@return tic-tac-toe.Mark?
function App:playGame(players)
	local i = 0
	self.conn:print("app.msg.game", self.board)
	while not self.board:full() do
		i = i % #players + 1
		local mark, player = Mark.all[i], players[i]
		local move = player:getMove(self.board, mark)
		self.board:setMark(move, mark)
		self.conn:print("app.msg.game", self.board)

		if self.board:won(mark) then
			return mark
		end
	end

	return nil
end

function App:__tostring()
	return tostring(self.board)
end

---@param winner tic-tac-toe.Mark?
function App:displayWinner(winner)
	if winner == nil then
		self.conn:print("app.msg.tied")
	else
		self.conn:print("app.msg.playerWon", winner)
	end
end

return AppClass
