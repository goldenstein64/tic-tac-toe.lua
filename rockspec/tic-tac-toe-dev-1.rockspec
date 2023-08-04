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
}
build = {
	type = "builtin",
	modules = {
		Computer = "tic-tac-toe/Computer.lua",
		Game = "tic-tac-toe/Game.lua",
		Human = "tic-tac-toe/Human.lua",
		Mark = "tic-tac-toe/Mark.lua",
		main = "tic-tac-toe/main.lua",
	},
}
