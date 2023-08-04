local Object = require("classic")

local Computer = require("tic-tac-toe.player.Computer")
local Human = require("tic-tac-toe.player.Human")
local Mark = require("tic-tac-toe.board.Mark")
local Board = require("tic-tac-toe.board.Board")
local IO = require("tic-tac-toe.IO")

local MockIO = require("spec.io.MockIO")

---@alias PlayerInput "H" | "C"
---@alias PlayerClass fun(board: Board, mark: Mark): Player

---@type { [PlayerInput]: PlayerClass }
local playerMap = {}

playerMap.H = Human --[[@as PlayerClass]]
playerMap.C = Computer --[[@as PlayerClass]]

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
---@return PlayerClass?
function App:promptPlayer(mark)
	local chosen = self.io:prompt("msg.pickPlayer", mark)
	local chosenClass = playerMap[chosen]
	if chosenClass then
		return chosenClass
	else
		self.io:print("err.invalidPlayer")
		return nil
	end
end

---@param board Board
---@return Player[]
function App:choosePlayers(board)
	local players = {} ---@type Player[]

	for i, mark in ipairs(self.allPlayers) do
		local chosenClass = self:promptPlayer(mark)
		while not chosenClass do
			chosenClass = self:promptPlayer(mark)
		end

		players[i] = chosenClass(board, mark)
	end

	return players
end

---@return Mark?
function App:playGame()
	local board = Board()

	local players = self:choosePlayers(board)
	self.io:print("msg.game", board)

	local currentPos = 1
	local currentMark ---@type Mark
	repeat
		currentMark = self.allPlayers[currentPos]
		local currentPlayer = players[currentPos]

		local position = currentPlayer:getMove()
		board:setMark(position, currentMark)
		self.io:print("msg.game", board)

		currentPos = currentPos % #self.allPlayers + 1
	until board:ended(currentMark)

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
	local winner = App:playGame()
	App:displayWinner(winner)
end

return App --[[@as App]]
