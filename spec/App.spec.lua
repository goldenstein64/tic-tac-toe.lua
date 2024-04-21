local MockIO = require("spec.io.MockIO")

local App = require("tic-tac-toe.App")
local Mark = require("tic-tac-toe.data.Mark")
local Board = require("tic-tac-toe.data.Board")
local Human = require("tic-tac-toe.player.Human")
local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")

local appIO = MockIO()
App.io = appIO

local humanIO = MockIO()
Human.io = humanIO

describe("App:promptPlayer", function()
	after_each(function()
		appIO:mockReset()
	end)

	it("returns the HardComputer class on input 'C' > 'H'", function()
		local app = App()
		appIO:mockInput("C", "H")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("msg.pickComputer")
		expect(playerClass).to.equal(HardComputer)
	end)

	it("returns the MediumComputer class on input 'C' > 'M'", function()
		local app = App()
		appIO:mockInput("C", "M")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("msg.pickComputer")
		expect(playerClass).to.equal(MediumComputer)
	end)

	it("returns the EasyComputer class on input 'C' > 'E'", function()
		local app = App()
		appIO:mockInput("C", "E")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("msg.pickComputer")
		expect(playerClass).to.equal(EasyComputer)
	end)

	it("emits an error message on an invalid input 'C' -> ??", function()
		local app = App()
		appIO:mockInput("C", "@")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("msg.pickComputer")
		expect(appIO).to.print("err.invalidComputer")
		expect(playerClass).to.be._nil()
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

	it("retries invalid inputs for players", function()
		local app = App()
		appIO:mockInput("@", "C", "H", "@", "@", "H")

		local players = app:choosePlayers()

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("err.invalidPlayer")

		expect(players).to.be.a("table")
		expect(players[Mark.X]).to.equal(HardComputer)
		expect(players[Mark.O]).to.equal(Human)
	end)

	it("retries invalid second inputs for computers", function()
		local app = App()
		appIO:mockInput("C", "@", "C", "M", "@", "C", "@", "C", "E")

		local players = app:choosePlayers()

		expect(appIO).to.print("msg.pickPlayer")
		expect(appIO).to.print("msg.pickComputer")
		expect(appIO).to.print("err.invalidPlayer")
		expect(appIO).to.print("err.invalidComputer")

		expect(players).to.be.a("table")
		expect(players[Mark.X]).to.equal(MediumComputer)
		expect(players[Mark.O]).to.equal(EasyComputer)
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

	it("can run a game of tic~tac~toe between humans", function()
		local app = App()

		-- a classic corner trap game
		humanIO:mockInput("1", "2", "7", "4", "9", "5", "8")

		local board = Board()
		local winner = app:playGame(board, Mark.X, { [Mark.X] = Human, [Mark.O] = Human })

		expect(winner).to.equal(Mark.X)
		expect(humanIO).to.print("msg.pickMove")
		expect(appIO).to.print("msg.game")
	end)

	it("can run a game of tic~tac~toe between computers", function()
		local app = App()

		expect(function()
			app:playGame(Board(), Mark.X, { [Mark.X] = HardComputer, [Mark.O] = HardComputer })
		end).not_to.throw()

		expect(appIO).to.print("msg.game")
	end)
end)
