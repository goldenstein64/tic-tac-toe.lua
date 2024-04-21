math.randomseed(os.time() / math.pi)

local ConsoleIO = require("tic-tac-toe-console.ConsoleIO")
local App = require("tic-tac-toe")
local Board = require("tic-tac-toe.data.Board")

local app = App(ConsoleIO)

local players = app:choosePlayers()
local winner = app:playGame(Board(), players)
app:displayWinner(winner)
