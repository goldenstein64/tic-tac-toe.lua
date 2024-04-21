local Object = require("classic")
local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")

local HardComputer = require("tic-tac-toe.player.HardComputer")
local Human = require("tic-tac-toe.player.Human")
local Mark = require("tic-tac-toe.data.Mark")
local Board = require("tic-tac-toe.data.Board")
local IO = require("tic-tac-toe.IO")

---@class Player
---@field getMove fun(self: any, board: Board, mark: Mark): integer

---@class App : Object
---@field super Object
local App = Object:extend()

---@class App.Class
---@overload fun(io: IO): App
local AppClass = App --[[@as App.Class]]

App.__name = "App"

---@param io IO
function App:new(io)
	self.io = io
end

---@param mark Mark
---@return Player?
function App:promptPlayer(mark)
	local chosenPlayer = self.io:prompt("app.msg.pickPlayer", mark)
	if chosenPlayer == "H" then
		return Human(self.io)
	elseif chosenPlayer == "C" then
		local chosenComputer = self.io:prompt("app.msg.pickComputer", mark)
		if chosenComputer == "E" then
			return EasyComputer
		elseif chosenComputer == "M" then
			return MediumComputer
		elseif chosenComputer == "H" then
			return HardComputer
		else
			self.io:print("app.err.invalidComputer")
			return nil
		end
	else
		self.io:print("app.err.invalidPlayer")
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
		self.io:print("app.msg.game", board)

		if board:won(mark) then
			return mark
		end
	end

	return nil
end

---@param winner Mark?
function App:displayWinner(winner)
	if winner == nil then
		self.io:print("app.msg.tied")
	else
		self.io:print("app.msg.playerWon", winner)
	end
end

return AppClass
