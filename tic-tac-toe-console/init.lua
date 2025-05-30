---a console application of tic-tac-toe

if _VERSION == "Lua 5.3" or _VERSION == "Lua 5.4" then
	math.randomseed(math.floor(os.time() / math.exp(1)))
else
	math.randomseed(os.time() / math.exp(1), os.time() / math.pi)
end

local ConsoleConnection = require("tic-tac-toe-console.ConsoleConnection")
local App = require("tic-tac-toe.init")

local conn = ConsoleConnection()
local app = App(conn)

local players = app:promptPlayers()
local winner = app:playGame(players)
app:displayWinner(winner)
