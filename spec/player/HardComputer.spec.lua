local random = require("random")

local Board = require("tic-tac-toe.data.Board")
local Mark = require("tic-tac-toe.data.Mark")
local HardComputer = require("tic-tac-toe.player.HardComputer")

describe("HardComputer", function()
	it("implements Player", function()
		expect(HardComputer.getMove).to.be.a("function")
	end)
end)

describe("HardComputer.terminal", function()
	it("returns 0 for a full board", function()
		--[[
			 O | X | X
			---|---|---
			 X | O | O
			---|---|---
			 O | X | X
		]]
		local board = Board.fromPattern("OXXXOOOXX")

		local value = HardComputer.terminal(board)

		expect(value).to.equal(0)
	end)

	it("returns 1 for a board that player X won", function()
		--[[
			 X | 2 | 3
			---|---|---
			 X | O | O
			---|---|---
			 X | 8 | 9
		]]
		local board = Board.fromPattern("X,,XOOX,,")

		local value = HardComputer.terminal(board)

		expect(value).to.equal(1)
	end)

	it("returns 1 for a full board that player X won", function()
		--[[
			 X | X | X
			---|---|---
			 X | O | O
			---|---|---
			 O | X | O
		]]
		local board = Board.fromPattern("XXXXOOOXO")

		local value = HardComputer.terminal(board)

		expect(value).to.equal(1)
	end)

	it("returns ~1 for a board that player O won", function()
		--[[
			O--
			OXX
			O-X
		]]
		local board = Board.fromPattern("O,,OXXO,X")

		local value = HardComputer.terminal(board)

		expect(value).to.equal(-1)
	end)

	it("returns ~1 for a full board that O won", function()
		--[[
			XXO
			XOX
			OOX
		]]
		local board = Board.fromPattern("XXOXOXOOX")

		local value = HardComputer.terminal(board)

		expect(value).to.equal(-1)
	end)
end)

describe("HardComputer:getMoves", function()
	it("has no side effects", function()
		local computer = HardComputer(random.new())
		local board = Board.fromPattern("XOXO,,,,,")
		local _ = computer:getMoves(board, Mark.X)
		expect(board.data).to.look.like({
			Mark.X,
			Mark.O,
			Mark.X,
			Mark.O,
			nil,
			nil,
			nil,
			nil,
			nil,
		})
	end)
end)
