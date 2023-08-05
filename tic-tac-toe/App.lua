local Object = require("classic")

local Computer = require("tic-tac-toe.player.Computer")
local Human = require("tic-tac-toe.player.Human")
local Mark = require("tic-tac-toe.board.Mark")
local Board = require("tic-tac-toe.board.Board")
local IO = require("tic-tac-toe.IO")

---@class Player
---@field getMove fun(board: Board, mark: Mark): integer

---@alias PlayerInput "H" | "C"

---@type { [PlayerInput]: Player }
local playerMap = {}

playerMap.H = Human
playerMap.C = Computer

---@class App : Object
---@field super Object
---@overload fun(): App
local App = Object:extend()

App.__name = "App"

App.io = IO({
	["msg.greeting"] = "This program runs a tic-tac-toe game.",
	["msg.pickPlayer"] = "Will player %s be a human or computer [H/C]: ",
	["msg.game"] = "%s\n",
	["msg.playerWon"] = "Player %s won!",
	["msg.tied"] = "There was a tie!",

	["err.invalidPlayer"] = "This does not match 'H' or 'C'!",
})

---@type Mark[]
App.allPlayers = { Mark.X, Mark.O }

---@param mark Mark
---@return Player?
function App:promptPlayer(mark)
	local chosen = self.io:prompt("msg.pickPlayer", mark)
	local chosenPlayer = playerMap[chosen]
	if chosenPlayer then
		return chosenPlayer
	else
		self.io:print("err.invalidPlayer")
		return nil
	end
end

---@return Player[]
function App:choosePlayers()
	local players = {} ---@type Player[]

	for i, mark in ipairs(self.allPlayers) do
		local chosenPlayer = self:promptPlayer(mark)
		while not chosenPlayer do
			chosenPlayer = self:promptPlayer(mark)
		end

		players[i] = chosenPlayer
	end

	return players
end

---@param board Board
---@param players Player[]
---@return Mark?
function App:playGame(board, players)
	self.io:print("msg.game", board)

	local currentPos = 1
	local currentMark ---@type Mark
	repeat
		currentMark = self.allPlayers[currentPos]
		local currentPlayer = players[currentPos]

		local position = currentPlayer.getMove(board, currentMark)
		board:setMark(position, currentMark)
		self.io:print("msg.game", board)

		currentPos = currentPos % #self.allPlayers + 1
	until board:won(currentMark) or board:full()

	return board:won(currentMark) and currentMark or nil
end

---@param winner Mark?
function App:displayWinner(winner)
	if winner == nil then
		self.io:print("msg.tied")
	else
		self.io:print("msg.playerWon", winner)
	end
end

function App:run()
	self.io:print("msg.greeting")
	local winner = self:playGame(Board(), self:choosePlayers())
	self:displayWinner(winner)
end

return App --[[@as App]]
