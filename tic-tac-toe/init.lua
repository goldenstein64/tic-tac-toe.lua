local class = require("middleclass")

local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")
local Human = require("tic-tac-toe.player.Human")
local Mark = require("tic-tac-toe.data.Mark")

---@class Player
---@field getMove fun(self: any, board: Board, mark: Mark): integer

---@class App : middleclass.Object
---@field class App.Class
---@field conn Connection
local App = class("App")

---@class App.Class : App, middleclass.Class
---@overload fun(conn: Connection): App

---@param conn Connection
function App:initialize(conn)
	self.conn = conn
end

---@param mark Mark
---@return Player?
function App:promptPlayer(mark)
	local chosenPlayer = self.conn:prompt("app.msg.pickPlayer", mark)
	if chosenPlayer == "H" then
		return Human(self.conn)
	elseif chosenPlayer == "C" then
		local chosenComputer = self.conn:prompt("app.msg.pickComputer", mark)
		if chosenComputer == "E" then
			return EasyComputer
		elseif chosenComputer == "M" then
			return MediumComputer
		elseif chosenComputer == "H" then
			return HardComputer
		else
			self.conn:print("app.err.invalidComputer")
			return nil
		end
	else
		self.conn:print("app.err.invalidPlayer")
		return nil
	end
end

---@return fun(): (Mark, Player)
function App:choosePlayers()
	local players = {} ---@type { [1]: Mark, [2]: Player }[]

	for _, mark in ipairs(Mark.all) do
		local player ---@type Player?
		repeat
			player = self:promptPlayer(mark)
		until player
		---@cast player Player
		table.insert(players, { mark, player } --[[@as { [1]: Mark, [2]: Player }]])
	end

	local i = 0
	return function()
		i = i % #players + 1
		---@diagnostic disable-next-line:return-type-mismatch
		return table.unpack(players[i], 1, 2)
	end
end

---@param board Board
---@param players fun(): (Mark, Player)
---@return Mark?
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

---@param winner Mark?
function App:displayWinner(winner)
	if winner == nil then
		self.conn:print("app.msg.tied")
	else
		self.conn:print("app.msg.playerWon", winner)
	end
end

return App --[[@as App.Class]]
