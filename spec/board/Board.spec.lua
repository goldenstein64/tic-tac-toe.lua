local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")

local board = Board.fromPattern

describe("Board:won", function()
	it("can detect all legal matches", function()
		local winPatterns = {
			"XXX,,,,,,",
			",,,XXX,,,",
			",,,,,,XXX",
			"X,,X,,X,,",
			",X,,X,,X,",
			",,X,,X,,X",
			"X,,,X,,,X",
			",,X,X,X,,",
		}

		for _, pattern in ipairs(winPatterns) do
			local oPattern = pattern:gsub("X", "O")
			expect(board(pattern):won(Mark.X)).to.be._true()
			expect(board(oPattern):won(Mark.O)).to.be._true()
			expect(board(pattern):won(Mark.O)).to.be._false()
			expect(board(oPattern):won(Mark.X)).to.be._false()
		end
	end)

	it("can detect when no match was made", function()
		local tiePatterns = {
			--[[
				 X | X | O
				---|---|---
				 O | O | X
				---|---|---
				 X | X | O
			]]
			"XXOOOXXXO",

			--[[
				 X | X | O
				---|---|---
				 O | O | X
				---|---|---
				 X | O | X
			]]
			"XXOOOXXOX",

			--[[
				 X | X | O
				---|---|---
				 O | X | X
				---|---|---
				 X | O | O
			]]
			"XXOOXXXOO",
		}

		for _, pattern in ipairs(tiePatterns) do
			expect(board(pattern):won(Mark.X)).to.be._false()
			expect(board(pattern):won(Mark.O)).to.be._false()
		end
	end)
end)

describe("Board:empty", function()
	it("can detect when a board is empty", function()
		expect(board(",,,,,,,,,"):empty()).to.be._true()
	end)

	it("can detect when a board is not empty", function()
		expect(board("XO,XO,XO,"):full()).to.be._false()
		expect(board("XXXXXXXX,"):full()).to.be._false()
		expect(board(",XXXXXXXX"):full()).to.be._false()
		expect(board("X,,,,,,,,"):full()).to.be._false()
		expect(board(",,,,,,,,X"):full()).to.be._false()
	end)
end)

describe("Board:full", function()
	it("can detect when a board is full", function()
		expect(board("XXOOOXXXO"):full()).to.be._true()
		expect(board("XXOOOXXOX"):full()).to.be._true()
		expect(board("XXOOXXXOO"):full()).to.be._true()
	end)

	it("can detect when a board is not full", function()
		expect(board("XO,XO,XO,"):full()).to.be._false()
		expect(board("XXXXXXXX,"):full()).to.be._false()
		expect(board(",XXXXXXXX"):full()).to.be._false()
		expect(board("X,,,,,,,,"):full()).to.be._false()
		expect(board(",,,,,,,,X"):full()).to.be._false()
	end)
end)

describe("Board:isMarkedWith", function()
	it("returns false for bad positions", function()
		local b = board(",,,,,,,,,")

		expect(b:isMarkedWith(0, nil)).to.be._false()
		expect(b:isMarkedWith(1, nil)).to.be._true()
		expect(b:isMarkedWith(2, nil)).to.be._true()
		expect(b:isMarkedWith(8, nil)).to.be._true()
		expect(b:isMarkedWith(9, nil)).to.be._true()
		expect(b:isMarkedWith(10, nil)).to.be._false()
	end)

	it("returns whether positions have the given mark", function()
		local b = board("XO,XO,XO,")

		expect(b:isMarkedWith(1, Mark.X)).to.be._true()
		expect(b:isMarkedWith(1, Mark.O)).to.be._false()
		expect(b:isMarkedWith(1, nil)).to.be._false()

		expect(b:isMarkedWith(2, Mark.O)).to.be._true()
		expect(b:isMarkedWith(2, Mark.X)).to.be._false()
		expect(b:isMarkedWith(2, nil)).to.be._false()

		expect(b:isMarkedWith(3, nil)).to.be._true()
		expect(b:isMarkedWith(3, Mark.X)).to.be._false()
		expect(b:isMarkedWith(3, Mark.O)).to.be._false()
	end)
end)

describe("Board:canMark", function()
	it("returns whether a position has no mark", function()
		local b = board("XO,XO,XO,")

		expect(b:canMark(1)).to.be._false()
		expect(b:canMark(2)).to.be._false()
		expect(b:canMark(3)).to.be._true()
		expect(b:canMark(4)).to.be._false()
		expect(b:canMark(5)).to.be._false()
		expect(b:canMark(6)).to.be._true()
		expect(b:canMark(7)).to.be._false()
		expect(b:canMark(8)).to.be._false()
		expect(b:canMark(9)).to.be._true()
	end)
end)

describe("Board:setMark", function()
	it("throws when attempting to set an occupied position", function()
		local b = board(",,X,,,,,,")

		expect(function()
			b:setMark(3, Mark.O)
		end).to.throw()

		expect(function()
			b:setMark(2, Mark.O)
		end).not_to.throw()
	end)

	for i = 1, 9 do
		local itName = string.format("changes the state of the board at position %d", i)
		it(itName, function()
			local b = board(",,,,,,,,,")

			expect(b:canMark(i)).to.be._true()
			b:setMark(i, Mark.X)
			expect(b:canMark(i)).to.be._false()
		end)
	end
end)
