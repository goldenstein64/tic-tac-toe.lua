local MockIO = require("spec.io.MockIO")

local Human = require("tic-tac-toe.player.Human")
local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")

local humanIO = MockIO()
Human.io = humanIO

describe("Human", function()
	it("implements Player", function()
		expect(Human.getMove).to.be.a("function")
	end)
end)

describe("Human.getMove", function()
	after_each(function()
		humanIO:mockReset()
	end)

	it("asks for a move from its IO object", function()
		local board = Board.fromPattern(",,,,,,,,,")
		humanIO:mockInput("2")

		local move = Human.getMove(board, Mark.X)
		expect(humanIO).to.print("msg.pickMove")
		expect(humanIO).to.never.print("err.NaN")
		expect(humanIO).to.never.print("err.outOfRange")
		expect(humanIO).to.never.print("err.occupied")

		expect(move).to.equal(2)
	end)

	it("states whether a position is occupied", function()
		local board = Board.fromPattern(",XO,,,,,,")
		humanIO:mockInput("3", "2", "1")

		local move = Human.getMove(board, Mark.X)

		-- 3 and 2 should get ignored
		expect(humanIO).to.print("msg.pickMove")
		expect(humanIO).to.never.print("err.NaN")
		expect(humanIO).to.never.print("err.outOfRange")
		expect(humanIO).to.print("err.occupied")

		expect(move).to.equal(1)
	end)

	it("states that out of range positions are invalid", function()
		local board = Board.fromPattern(",,,,,,,,,")
		humanIO:mockInput("0", "1")

		local move = Human.getMove(board, Mark.X)

		expect(humanIO).to.print("msg.pickMove")
		expect(humanIO).to.never.print("err.NaN")
		expect(humanIO).to.print("err.outOfRange")
		expect(humanIO).to.never.print("err.occupied")

		expect(move).to.equal(1)
	end)

	it("states that non~positions are invalid moves", function()
		local board = Board.fromPattern(",,,,,,,,,")
		humanIO:mockInput("@", "1")

		local move = Human.getMove(board, Mark.X)

		-- @ should get ignored
		expect(humanIO).to.print("msg.pickMove")
		expect(humanIO).to.print("err.NaN")
		expect(humanIO).to.never.print("err.outOfRange")
		expect(humanIO).to.never.print("err.occupied")

		expect(move).to.equal(1)
	end)
end)
