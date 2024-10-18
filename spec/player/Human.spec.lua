local MockConnection = require("spec.io.MockConnection")

local Human = require("tic-tac-toe.player.Human")
local Board = require("tic-tac-toe.data.Board")
local Mark = require("tic-tac-toe.data.Mark")

describe("Human", function()
	it("implements Player", function()
		expect(Human.getMove).to.be.a("function")
	end)
end)

describe("Human.getMove", function()
	it("asks for a move from its connection", function()
		local board = Board.fromPattern(",,,,,,,,,")
		local conn = MockConnection()
		local human = Human(conn)
		conn:mockInput("2")

		local move = human:getMove(board, Mark.X)
		expect(conn).to.print("human.msg.pickMove")
		expect(conn).to.never.print("human.err.NaN")
		expect(conn).to.never.print("human.err.outOfRange")
		expect(conn).to.never.print("human.err.occupied")

		expect(move).to.equal(2)
	end)

	it("states whether a position is occupied", function()
		local board = Board.fromPattern(",XO,,,,,,")
		local conn = MockConnection()
		local human = Human(conn)
		conn:mockInput("3", "2", "1")

		local move = human:getMove(board, Mark.X)

		-- 3 and 2 should get ignored
		expect(conn).to.print("human.msg.pickMove")
		expect(conn).to.never.print("human.err.NaN")
		expect(conn).to.never.print("human.err.outOfRange")
		expect(conn).to.print("human.err.occupied")

		expect(move).to.equal(1)
	end)

	it("states that out of range positions are invalid", function()
		local board = Board.fromPattern(",,,,,,,,,")
		local conn = MockConnection()
		local human = Human(conn)
		conn:mockInput("0", "1")

		local move = human:getMove(board, Mark.X)

		expect(conn).to.print("human.msg.pickMove")
		expect(conn).to.never.print("human.err.NaN")
		expect(conn).to.print("human.err.outOfRange")
		expect(conn).to.never.print("human.err.occupied")

		expect(move).to.equal(1)
	end)

	it("states that non~positions are invalid moves", function()
		local board = Board.fromPattern(",,,,,,,,,")
		local conn = MockConnection()
		local human = Human(conn)
		conn:mockInput("@", "1")

		local move = human:getMove(board, Mark.X)

		-- @ should get ignored
		expect(conn).to.print("human.msg.pickMove")
		expect(conn).to.print("human.err.NaN")
		expect(conn).to.never.print("human.err.outOfRange")
		expect(conn).to.never.print("human.err.occupied")

		expect(move).to.equal(1)
	end)
end)
