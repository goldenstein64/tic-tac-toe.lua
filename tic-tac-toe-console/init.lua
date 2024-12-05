math.randomseed(os.time() / math.exp(1), os.time() / math.pi)

local ConsoleConnection = require("tic-tac-toe-console.ConsoleConnection")
local App = require("tic-tac-toe")

local conn = ConsoleConnection()
local app = App(conn)

local players = app:promptPlayers()
local winner = app:playGame(players)
app:displayWinner(winner)
