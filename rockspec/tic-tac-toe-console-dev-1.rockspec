package = "tic-tac-toe-console"
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
	"tic-tac-toe == dev-1",
}
build = {
	type = "builtin",
	modules = {
		["tic-tac-toe-console.init"] = "tic-tac-toe-console/init.lua",
		["tic-tac-toe-console.ConsoleConnection"] = "tic-tac-toe-console/ConsoleConnection.lua",
	},
}
