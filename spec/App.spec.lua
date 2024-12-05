local MockConnection = require("spec.io.MockConnection")

local random = require("random")
local App = require("tic-tac-toe")
local Mark = require("tic-tac-toe.data.Mark")
local Human = require("tic-tac-toe.player.Human")
local EasyComputer = require("tic-tac-toe.player.EasyComputer")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")

describe("App:promptPlayerOnce", function()
	it("returns the HardComputer class on input 'C' > 'H'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "H")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(playerClass).to.be.an.instance.of(HardComputer)
	end)

	it("returns the MediumComputer class on input 'C' > 'M'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "M")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(playerClass).to.be.an.instance.of(MediumComputer)
	end)

	it("returns the EasyComputer class on input 'C' > 'E'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "E")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(playerClass).to.be.an.instance.of(EasyComputer)
	end)

	it("emits an error message on an invalid input 'C' -> ??", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "@")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
			{ message = "app.err.invalidComputer", "@" },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(playerClass).to.be_nil()
	end)

	it("returns the Human class on input 'H'", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("H")

		local player = app:promptPlayerOnce(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(player).to.be.an.instance.of(Human)
	end)

	it("emits an error message on an invalid input", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("@")

		local playerClass = app:promptPlayerOnce(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.err.invalidPlayer", "@" },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(playerClass).to.be_nil()
	end)
end)

describe("App:promptPlayers", function()
	it("retries invalid inputs for players", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("@", "C", "H", "@", "@", "H")

		local players = app:promptPlayers()

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.err.invalidPlayer", "@" },
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
			{ message = "app.msg.pickPlayer", Mark.O },
			{ message = "app.err.invalidPlayer", "@" },
			{ message = "app.msg.pickPlayer", Mark.O },
			{ message = "app.err.invalidPlayer", "@" },
			{ message = "app.msg.pickPlayer", Mark.O },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(players).to.be.a("table")
		expect(players[1]).to.be.an.instance.of(HardComputer)
		expect(players[2]).to.be.an.instance.of(Human)
	end)

	it("retries invalid second inputs for computers", function()
		local conn = MockConnection()
		local app = App(conn)
		conn:mockInput("C", "@", "C", "M", "@", "C", "@", "C", "E")

		local players = app:promptPlayers()

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
			{ message = "app.err.invalidComputer", "@" },
			{ message = "app.msg.pickPlayer", Mark.X },
			{ message = "app.msg.pickComputer", Mark.X },
			{ message = "app.msg.pickPlayer", Mark.O },
			{ message = "app.err.invalidPlayer", "@" },
			{ message = "app.msg.pickPlayer", Mark.O },
			{ message = "app.msg.pickComputer", Mark.O },
			{ message = "app.err.invalidComputer", "@" },
			{ message = "app.msg.pickPlayer", Mark.O },
			{ message = "app.msg.pickComputer", Mark.O },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])

		expect(players).to.be.a("table")
		expect(players[1]).to.be.an.instance.of(MediumComputer)
		expect(players[2]).to.be.an.instance.of(EasyComputer)
	end)
end)

describe("App:displayWinner", function()
	it("outputs a tie when given a nil argument", function()
		local conn = MockConnection()
		local app = App(conn)

		app:displayWinner(nil)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.tied" },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])
	end)

	it("outputs the winner when given Mark.X as an argument", function()
		local conn = MockConnection()
		local app = App(conn)

		app:displayWinner(Mark.X)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.playerWon", Mark.X },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])
	end)

	it("outputs the winner when given Mark.O as an argument", function()
		local conn = MockConnection()
		local app = App(conn)

		app:displayWinner(Mark.O)

		expect(conn.outputs).to.look.like({
			{ message = "app.msg.playerWon", Mark.O },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])
	end)
end)

describe("App:playTurn", function()
	it("returns false, nil after marking an empty board", function()
		local conn = MockConnection()
		local app = App(conn)

		conn:mockInput("1")

		local ended, winner = app:playTurn(Human(conn), Mark.X)
		expect(ended).to.be_false()
		expect(winner).to.be_nil()
		expect(app.board:isMarkedWith(1, Mark.X)).to.be_true()
		expect(conn.outputs).to.look.like({
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
		})
	end)

	it("can run one turn of tic~tac~toe with a computer", function()
		local conn = MockConnection()
		local app = App(conn)

		local ended, winner = app:playTurn(EasyComputer(random.new(0)), Mark.X)
		expect(ended).to.be_false()
		expect(winner).to.be_nil()
		expect(conn.outputs).to.look.like({
			{ message = "app.msg.game", app.board },
		})
	end)

	it("returns true, nil after a full board and tie", function()
		local conn = MockConnection()
		-- O X X
		-- - O O
		-- O X X
		local app = App(conn, "OXX,OOOXX")

		conn:mockInput("4")

		local ended, winner = app:playTurn(Human(conn), Mark.X)
		expect(ended).to.be_true()
		expect(winner).to.be_nil()
		expect(conn.outputs).to.look.like({
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
		})
	end)

	it("returns true, X after X wins", function()
		local conn = MockConnection()
		-- X - X
		-- O - -
		-- - - O
		local app = App(conn, "X,XO,,,,O")

		conn:mockInput("2")

		local ended, winner = app:playTurn(Human(conn), Mark.X)
		expect(ended).to.be_true()
		expect(winner).to.equal(Mark.X)
		expect(conn.outputs).to.look.like({
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
		})
	end)

	it("returns true, O after O wins", function()
		local conn = MockConnection()
		-- X - X
		-- O - O
		-- X - -
		local app = App(conn, "X,XO,O,X,")

		conn:mockInput("5")

		local ended, winner = app:playTurn(Human(conn), Mark.O)
		expect(ended).to.be_true()
		expect(winner).to.equal(Mark.O)
		expect(conn.outputs).to.look.like({
			{ message = "human.msg.pickMove", Mark.O },
			{ message = "app.msg.game", app.board },
		})
	end)

	it("returns true, X after X wins on a full board", function()
		local conn = MockConnection()
		-- X O X
		-- O O X
		-- O X -
		local app = App(conn, "XOXOOXOX,")

		conn:mockInput("9")

		local ended, winner = app:playTurn(Human(conn), Mark.X)
		expect(ended).to.be_true()
		expect(winner).to.equal(Mark.X)
		expect(conn.outputs).to.look.like({
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
		})
	end)

	-- this will never happen in a real game, but it's still good to check for
	-- soundness
	it("returns true, O after O wins on a full board", function()
		local conn = MockConnection()
		-- X X O
		-- X O O
		-- - X X
		local app = App(conn, "XXOXOO,XX")

		conn:mockInput("7")

		local ended, winner = app:playTurn(Human(conn), Mark.O)
		expect(ended).to.be_true()
		expect(winner).to.equal(Mark.O)
		expect(conn.outputs).to.look.like({
			{ message = "human.msg.pickMove", Mark.O },
			{ message = "app.msg.game", app.board },
		})
	end)
end)

describe("App:playGame", function()
	it("can run a game of tic~tac~toe between humans", function()
		local conn = MockConnection()
		local app = App(conn)

		-- a classic corner trap game
		conn:mockInput("1", "2", "7", "4", "9", "5", "8")

		local winner = app:playGame({ Human(conn), Human(conn) })

		expect(winner).to.equal(Mark.X)
		expect(conn.outputs).to.look.like({
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.O },
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.O },
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.O },
			{ message = "app.msg.game", app.board },
			{ message = "human.msg.pickMove", Mark.X },
			{ message = "app.msg.game", app.board },
		} --[[@as tic-tac-toe.MockConnection.Message[] ]])
	end)

	it("can run a game of tic~tac~toe between computers", function()
		local conn = MockConnection()
		local app = App(conn)

		app:playGame({ HardComputer(random.new()), HardComputer(random.new()) })

		expect(conn).to.print("app.msg.game")
	end)
end)
