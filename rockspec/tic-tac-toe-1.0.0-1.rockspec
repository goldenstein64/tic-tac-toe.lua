rockspec_format = "3.0"
package = "tic-tac-toe"
version = "1.0.0-1"
source = {
	url = "git+https://github.com/goldenstein64/tic-tac-toe-lua.git",
	tag = "v1.0.0",
}
description = {
	homepage = "https://github.com/goldenstein64/tic-tac-toe-lua",
	issues_url = "https://github.com/goldenstein64/tic-tac-toe-lua/issues",
	license = "MIT",
}
dependencies = {
	"lua ~> 5.1",
	"lrandom == 20180729-1",
	"middleclass ~> 4.1",
}
test_dependencies = {
	"busted ~> 2.2",
	"bustez ~> 0.1",
}
build = {
	type = "builtin",
	modules = {
		["tic-tac-toe.init"] = "tic-tac-toe/init.lua",

		["tic-tac-toe.data.Mark"] = "tic-tac-toe/data/Mark.lua",
		["tic-tac-toe.data.Board"] = "tic-tac-toe/data/Board.lua",
		["tic-tac-toe.data.Message"] = "tic-tac-toe/data/Message.lua",

		["tic-tac-toe.player.EasyComputer"] = "tic-tac-toe/player/EasyComputer.lua",
		["tic-tac-toe.player.MediumComputer"] = "tic-tac-toe/player/MediumComputer.lua",
		["tic-tac-toe.player.HardComputer"] = "tic-tac-toe/player/HardComputer.lua",
		["tic-tac-toe.player.Computer"] = "tic-tac-toe/player/Computer.lua",
		["tic-tac-toe.player.Human"] = "tic-tac-toe/player/Human.lua",
	},
}
