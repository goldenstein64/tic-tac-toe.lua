local MockIO = require("spec.io.MockIO")

local App = require("tic-tac-toe.App")
local Mark = require("tic-tac-toe.board.Mark")
local Board = require("tic-tac-toe.board.Board")
local Computer = require("tic-tac-toe.player.Computer")
local Human = require("tic-tac-toe.player.Human")

local appIO = MockIO()
App.io = appIO

local humanIO = MockIO()
Human.io = humanIO

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

	it("retries invalid inputs for each player", function()
		local app = App()
		appIO:mockInput("@", "C", "@", "@", "H")

		local players = app:choosePlayers()

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("err.invalidPlayer")

		expect(players).to.be.a("table")
		expect(players[Mark.X]).to.equal(Computer)
		expect(players[Mark.O]).to.equal(Human)
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

describe("App:playGame", function()
	after_each(function()
		humanIO:mockReset()
	end)

	it("can run a game of tic-tac-toe between humans", function()
		local app = App()

		-- a classic corner trap game
		humanIO:mockInput("1", "2", "7", "4", "9", "5", "8")

		local board = Board()
		local winner = app:playGame(board, Mark.X, { [Mark.X] = Human, [Mark.O] = Human })

		expect(winner).to.equal(Mark.X)
		expect(humanIO).to.print("msg.pickMove")
		expect(appIO).to.print("msg.game")
	end)

	it("can run a game of tic-tac-toe between computers", function()
		local app = App()

		expect(function()
			app:playGame(Board(), Mark.X, { [Mark.X] = Computer, [Mark.O] = Computer })
		end).not_to.throw()

		expect(appIO).to.print("msg.game")
	end)
end)
