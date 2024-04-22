local class = require("middleclass")
local random = require("random")

local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")
local Human = require("tic-tac-toe.player.Human")
local Mark = require("tic-tac-toe.data.Mark")

---@class tic-tac-toe.Player
---@field getMove fun(self: any, board: tic-tac-toe.Board, mark: tic-tac-toe.Mark): integer

---@class tic-tac-toe.App : middleclass.Object
---@field class tic-tac-toe.App.Class
---@field conn tic-tac-toe.Connection
local App = class("App")

---@class tic-tac-toe.App.Class : tic-tac-toe.App, middleclass.Class
---@overload fun(conn: tic-tac-toe.Connection): tic-tac-toe.App

---@param conn tic-tac-toe.Connection
function App:initialize(conn)
	self.conn = conn
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

---@return fun(): (tic-tac-toe.Mark, tic-tac-toe.Player)
function App:choosePlayers()
	---@type tic-tac-toe.Player[]
	local players = {}
	for i, mark in ipairs(Mark.all) do
		players[i] = self:promptPlayer(mark)
	end

	local i = 0
	return function()
		i = i % #players + 1
		---@diagnostic disable-next-line:return-type-mismatch
		return Mark.all[i], players[i]
	end
end

---@param board tic-tac-toe.Board
---@param players fun(): (tic-tac-toe.Mark, tic-tac-toe.Player)
---@return tic-tac-toe.Mark?
function App:playGame(board, players)
	while not board:full() do
		local mark, player = players()
		local move = player:getMove(board, mark)
		board:setMark(move, mark)
		self.conn:print("app.msg.game", board)

		if board:won(mark) then
			return mark
		end
	end

	return nil
end

---@param winner tic-tac-toe.Mark?
function App:displayWinner(winner)
	if winner == nil then
		self.conn:print("app.msg.tied")
	else
		self.conn:print("app.msg.playerWon", winner)
	end
end

return App --[[@as tic-tac-toe.App.Class]]
