math.randomseed(os.time() / math.pi)

local ConsoleIO = require("tic-tac-toe-console.ConsoleIO")
local App = require("tic-tac-toe")

local app = App(ConsoleIO)

app:run()
