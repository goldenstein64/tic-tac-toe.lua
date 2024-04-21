math.randomseed(os.time() / math.pi)

local ConsoleConnection = require("tic-tac-toe-console.ConsoleConnection")
local App = require("tic-tac-toe")
local Board = require("tic-tac-toe.data.Board")

local conn = ConsoleConnection()
local app = App(conn)

local players = app:choosePlayers()
local winner = app:playGame(Board(), players)
app:displayWinner(winner)
