local MockConnection = require("spec.io.MockConnection")

local random = require("random")
local App = require("tic-tac-toe")
local Mark = require("tic-tac-toe.data.Mark")
local Board = require("tic-tac-toe.data.Board")
local Human = require("tic-tac-toe.player.Human")
local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")

---@param players tic-tac-toe.Player[]
---@return fun(): (tic-tac-toe.Mark, tic-tac-toe.Player)
local function cyclePlayers(players)
	local i = 0
	return function()
		i = i % 2 + 1
		return Mark.all[i], players[i]
	end
end

describe("App:promptPlayerOnce", function()
	it("returns the HardComputer class on input 'C' > 'H'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "H")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.msg.pickComputer")
		expect(playerClass).to.be.an.instance.of(HardComputer)
	end)

	it("returns the MediumComputer class on input 'C' > 'M'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "M")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.msg.pickComputer")
		expect(playerClass).to.be.an.instance.of(MediumComputer)
	end)

	it("returns the EasyComputer class on input 'C' > 'E'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "E")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.msg.pickComputer")
		expect(playerClass).to.be.an.instance.of(EasyComputer)
	end)

	it("emits an error message on an invalid input 'C' -> ??", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "@")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.msg.pickComputer")
		expect(conn).to.print("app.err.invalidComputer")
		expect(playerClass).to.be._nil()
	end)

	it("returns the Human class on input 'H'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("H")

		local player = app:promptPlayerOnce(Mark.X)

		expect(conn).to.print("app.msg.pickPlayer")
		expect(player).to.be.an.instance.of(Human)
	end)

	it("emits an error message on an invalid input", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("@")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.err.invalidPlayer")
		expect(playerClass).to.be._nil()
	end)
end)

describe("App:choosePlayers", function()
	it("retries invalid inputs for players", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("@", "C", "H", "@", "@", "H")

		local players = app:choosePlayers()

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.err.invalidPlayer")

		expect(players).to.be.a("function")
		local mark1, player1 = players()
		expect(mark1).to.equal(Mark.X)
		expect(player1).to.be.an.instance.of(HardComputer)

		local mark2, player2 = players()
		expect(mark2).to.equal(Mark.O)
		expect(player2).to.be.an.instance.of(Human)
	end)

	it("retries invalid second inputs for computers", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "@", "C", "M", "@", "C", "@", "C", "E")

		local players = app:choosePlayers()

		expect(conn).to.print("app.msg.pickPlayer")
		expect(conn).to.print("app.msg.pickComputer")
		expect(conn).to.print("app.err.invalidPlayer")
		expect(conn).to.print("app.err.invalidComputer")

		expect(players).to.be.a("function")
		local mark1, player1 = players()
		expect(mark1).to.equal(Mark.X)
		expect(player1).to.be.an.instance.of(MediumComputer)

		local mark2, player2 = players()
		expect(mark2).to.equal(Mark.O)
		expect(player2).to.be.an.instance.of(EasyComputer)
	end)
end)

describe("App:displayWinner", function()
	it("outputs a tie when given a nil argument", function()
		local conn = MockConnection()
		local app = App(conn)

		app:displayWinner(nil)

		expect(conn).to.print("app.msg.tied")
	end)

	it("outputs the winner when given Mark.X as an argument", function()
		local conn = MockConnection()
		local app = App(conn)

		app:displayWinner(Mark.X)

		expect(conn).to.print("app.msg.playerWon")
	end)

	it("outputs the winner when given Mark.O as an argument", function()
		local conn = MockConnection()
		local app = App(conn)

		app:displayWinner(Mark.O)

		expect(conn).to.print("app.msg.playerWon")
	end)
end)

describe("App:playGame", function()
	it("can run a game of tic~tac~toe between humans", function()
		local conn = MockConnection()
		local app = App(conn)

		-- a classic corner trap game
		conn:mockInput("1", "2", "7", "4", "9", "5", "8")

		local board = Board()
		local winner = app:playGame(board, cyclePlayers({ Human(conn), Human(conn) }))

		expect(winner).to.equal(Mark.X)
		expect(conn).to.print("human.msg.pickMove")
		expect(conn).to.print("app.msg.game")
	end)

	it("can run a game of tic~tac~toe between computers", function()
		local conn = MockConnection()
		local app = App(conn)

		app:playGame(Board(), cyclePlayers({ HardComputer(random.new()), HardComputer(random.new()) }))

		expect(conn).to.print("app.msg.game")
	end)
end)
