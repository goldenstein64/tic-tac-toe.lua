package = "tic-tac-toe"
version = "dev-1"
source = {
	url = "*** please add URL for source tarball, zip or repository here ***",
}
description = {
	homepage = "*** please enter a project homepage ***",
	license = "*** please specify a license ***",
}
dependencies = {
	"lua ~> 5.1",
	"lrandom == 20180729-1",
	"middleclass ~> 4.1",
}
test_dependencies = {
	"busted ~> 2.2",
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
		["tic-tac-toe.player.Human"] = "tic-tac-toe/player/Human.lua",
	},
}
