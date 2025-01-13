rockspec_format = "3.0"
package = "tic-tac-toe-console"
version = "1.0.0-1"
source = {
	url = "git+https://github.com/goldenstein64/tic-tac-toe-lua.git",
	dir = "tic-tac-toe-console",
}
description = {
	homepage = "https://github.com/goldenstein64/tic-tac-toe-lua",
	issues_url = "https://github.com/goldenstein64/tic-tac-toe-lua/issues",
	license = "MIT",
}
dependencies = {
	"lua ~> 5.1",
	"tic-tac-toe ~> 1.0",
	"middleclass ~> 4.1",
}
build = {
	type = "builtin",
	modules = {
		["tic-tac-toe-console.init"] = "tic-tac-toe-console/init.lua",
		["tic-tac-toe-console.ConsoleConnection"] = "tic-tac-toe-console/ConsoleConnection.lua",
	},
}
