local MockIO = require("spec.io.MockIO")

local App = require("tic-tac-toe")
local Mark = require("tic-tac-toe.data.Mark")
local Board = require("tic-tac-toe.data.Board")
local Human = require("tic-tac-toe.player.Human")
local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")

---@param players Player[]
---@return fun(): (Mark, Player)
local function cyclePlayers(players)
	local i = 0
	return function()
		i = i % 2 + 1
		return Mark.all[i], players[i]
	end
end

describe("App:promptPlayer", function()
	it("returns the HardComputer class on input 'C' > 'H'", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("C", "H")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.msg.pickComputer")
		expect(playerClass).to.equal(HardComputer)
	end)

	it("returns the MediumComputer class on input 'C' > 'M'", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("C", "M")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.msg.pickComputer")
		expect(playerClass).to.equal(MediumComputer)
	end)

	it("returns the EasyComputer class on input 'C' > 'E'", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("C", "E")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.msg.pickComputer")
		expect(playerClass).to.equal(EasyComputer)
	end)

	it("emits an error message on an invalid input 'C' -> ??", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("C", "@")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.msg.pickComputer")
		expect(appIO).to.print("app.err.invalidComputer")
		expect(playerClass).to.be._nil()
	end)

	it("returns the Human class on input 'H'", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("H")

		local player = app:promptPlayer(Mark.X)

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(player).to.be.an.instance.of(Human)
	end)

	it("emits an error message on an invalid input", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("@")

		local playerClass = app:promptPlayer(Mark.X)

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.err.invalidPlayer")
		expect(playerClass).to.be._nil()
	end)
end)

describe("App:choosePlayers", function()
	it("retries invalid inputs for players", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("@", "C", "H", "@", "@", "H")

		local players = app:choosePlayers()

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.err.invalidPlayer")

		expect(players).to.be.a("function")
		local mark1, player1 = players()
		expect(mark1).to.equal(Mark.X)
		expect(player1).to.equal(HardComputer)

		local mark2, player2 = players()
		expect(mark2).to.equal(Mark.O)
		expect(player2).to.be.an.instance.of(Human)
	end)

	it("retries invalid second inputs for computers", function()
		local appIO = MockIO()
		local app = App(appIO)
		appIO:mockInput("C", "@", "C", "M", "@", "C", "@", "C", "E")

		local players = app:choosePlayers()

		expect(appIO).to.print("app.msg.pickPlayer")
		expect(appIO).to.print("app.msg.pickComputer")
		expect(appIO).to.print("app.err.invalidPlayer")
		expect(appIO).to.print("app.err.invalidComputer")

		expect(players).to.be.a("function")
		local mark1, player1 = players()
		expect(mark1).to.equal(Mark.X)
		expect(player1).to.equal(MediumComputer)

		local mark2, player2 = players()
		expect(mark2).to.equal(Mark.O)
		expect(player2).to.equal(EasyComputer)
	end)
end)

describe("App:displayWinner", function()
	it("outputs a tie when given a nil argument", function()
		local appIO = MockIO()
		local app = App(appIO)

		app:displayWinner(nil)

		expect(appIO).to.print("app.msg.tied")
	end)

	it("outputs the winner when given Mark.X as an argument", function()
		local appIO = MockIO()
		local app = App(appIO)

		app:displayWinner(Mark.X)

		expect(appIO).to.print("app.msg.playerWon")
	end)

	it("outputs the winner when given Mark.O as an argument", function()
		local appIO = MockIO()
		local app = App(appIO)

		app:displayWinner(Mark.O)

		expect(appIO).to.print("app.msg.playerWon")
	end)
end)

describe("App:playGame", function()
	it("can run a game of tic~tac~toe between humans", function()
		local appIO = MockIO()
		local app = App(appIO)

		-- a classic corner trap game
		appIO:mockInput("1", "2", "7", "4", "9", "5", "8")

		local board = Board()
		local winner = app:playGame(board, cyclePlayers({ Human(appIO), Human(appIO) }))

		expect(winner).to.equal(Mark.X)
		expect(appIO).to.print("human.msg.pickMove")
		expect(appIO).to.print("app.msg.game")
	end)

	it("can run a game of tic~tac~toe between computers", function()
		local appIO = MockIO()
		local app = App(appIO)

		expect(function()
			app:playGame(Board(), cyclePlayers({ HardComputer, HardComputer }))
		end).not_to.throw()

		expect(appIO).to.print("app.msg.game")
	end)
end)
