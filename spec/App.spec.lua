local MockIO = require("spec.io.MockIO")

local App = require("tic-tac-toe.App")
local Mark = require("tic-tac-toe.board.Mark")
local Board = require("tic-tac-toe.board.Board")
local Computer = require("tic-tac-toe.player.Computer")
local Human = require("tic-tac-toe.player.Human")

local appIO = MockIO()
App.io = appIO

describe("App:promptPlayer", function()
	after_each(function()
		appIO:mockReset()
	end)

	it("returns the Computer class on input 'C'", function()
		local app = App()
		appIO:mockInput("C")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(playerClass).to.equal(Computer)
	end)

	it("returns the Human class on input 'H'", function()
		local app = App()
		appIO:mockInput("H")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(playerClass).to.equal(Human)
	end)

	it("emits an error message on an invalid input", function()
		local app = App()
		appIO:mockInput("@")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("err.invalidPlayer")
		expect(playerClass).to.be._nil()
	end)
end)

describe("App:choosePlayers", function()
	after_each(function()
		appIO:mockReset()
	end)

	it("returns a list of players according to App.allPlayers", function()
		local board = Board()
		local app = App()
		appIO:mockInput("H")

		app.allPlayers = { Mark.X }
		local players = app:choosePlayers(board)

		expect(appIO).to.print("msg.pickPlayer")

		expect(players).to.be.a("table")

		local playerX = players[1]
		expect(playerX).to.be.an.instance.of(Human)

		local playerO = players[2]
		expect(playerO).to.be._nil()
	end)

	it("retries invalid inputs for each player", function()
		local board = Board()
		local app = App()
		appIO:mockInput("@", "C", "@", "@", "H")

		local players = app:choosePlayers(board)

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("err.invalidPlayer")

		expect(players).to.be.a("table")

		local playerX = players[1]
		expect(playerX).to.be.an.instance.of(Computer)

		local playerO = players[2]
		expect(playerO).to.be.an.instance.of(Human)
	end)
end)

describe("App:displayWinner", function()
	it("outputs a tie when given a nil argument", function()
		local app = App()

		app:displayWinner(nil)

		expect(appIO).to.print("msg.tied")
	end)

	it("outputs the winner when given Mark.X as an argument", function()
		local app = App()

		app:displayWinner(Mark.X)

		expect(appIO).to.print("msg.playerWon")
	end)

	it("outputs the winner when given Mark.O as an argument", function()
		local app = App()

		app:displayWinner(Mark.O)

		expect(appIO).to.print("msg.playerWon")
	end)
end)
