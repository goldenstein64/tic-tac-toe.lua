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

---@return { [Mark]: Player }
function App:choosePlayers()
	local players = {} ---@type { [Mark]: Player }

	local mark = Mark.X
	while not players[mark] do
		players[mark] = self:promptPlayer(mark)
		mark = players[mark] and mark:other() or mark
	end

	return players
end

---@param board Board
---@param mark Mark
---@param players { [Mark]: Player }
---@return Mark?
function App:playGame(board, mark, players)
	local otherMark = mark:other()
	if board:won(otherMark) then
		return otherMark
	elseif board:full() then
		return nil
	else
		local player = players[mark]
		local move = player:getMove(board, mark)
		board:setMark(move, mark)
		self.io:print("app.msg.game", board)
		return self:playGame(board, otherMark, players)
	end
end

---@param winner Mark?
function App:displayWinner(winner)
	if winner == nil then
		self.io:print("app.msg.tied")
	else
		self.io:print("app.msg.playerWon", winner)
	end
end

function App:run()
	self.io:print("app.msg.greeting")
	local winner = self:playGame(Board(), Mark.X, self:choosePlayers())
	self:displayWinner(winner)
end

return AppClass
