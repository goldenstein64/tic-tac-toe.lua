local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")
local Computer = require("tic-tac-toe.player.Computer")

describe("Computer", function()
	it("implements Player", function()
		expect(Computer.getMove).to.be.a("function")
	end)
end)

describe("Computer:getMove", function()
	it("can detect winning moves for X", function()
		--[[
			 1 | X | X
			---|---|---
			 4 | O | O
			---|---|---
			 7 | 8 | 9
		]]
		local board = Board.fromPattern(",XX,OO,,,")

		local move = Computer.getMove(board, Mark.X)

		expect(move).to.equal(1)
	end)

	it("can detect winning moves for O", function()
		--[[
			 1 | O | O
			---|---|---
			 4 | X | X
			---|---|---
			 7 | 8 | X
		]]
		local board = Board.fromPattern(",OO,XX,,X")

		local move = Computer.getMove(board, Mark.O)

		expect(move).to.equal(1)
	end)

	it("can detect blocking moves for X", function()
		--[[
			 O | 2 | 3
			---|---|---
			 O | 5 | X
			---|---|---
			 7 | X | 9
		]]
		local board = Board.fromPattern("O,,O,X,X,")

		local move = Computer.getMove(board, Mark.X)

		expect(move).to.equal(7)
	end)

	it("can detect blocking moves for O", function()
		--[[
			 1 | O | 3
			---|---|---
			 X | 5 | 6
			---|---|---
			 X | X | O
		]]
		local board = Board.fromPattern(",O,X,,XXO")

		local move = Computer.getMove(board, Mark.O)

		expect(move).to.equal(1)
	end)

	it("can detect trapping moves for X", function()
		--[[
			 1 | X | 3
			---|---|---
			 O | 5 | X
			---|---|---
			 7 | O | 9
		]]
		local board = Board.fromPattern(",X,O,X,O,")

		local move = Computer.getMove(board, Mark.X)

		expect(move).to.equal(3)
	end)

	it("can detect trapping moves for O", function()
		--[[
			 1 | X | 3
			---|---|---
			 O | X | X
			---|---|---
			 7 | O | 9
		]]
		local board = Board.fromPattern(",X,OXX,O,")

		local move = Computer.getMove(board, Mark.O)

		expect(move).to.equal(7)
	end)

	it("doesn't choose wrong in ',XXXOOOX,'", function()
		--[[
			 1 | X | X
			---|---|---
			 X | O | O
			---|---|---
			 O | X | 9
		]]
		local board = Board.fromPattern(",XXXOOOX,")

		local move = Computer.getMove(board, Mark.O)

		expect(move).to.equal(1)
	end)
end)

describe("Computer.terminal", function()
	it("returns 0 for a full board", function()
		--[[
			 O | X | X
			---|---|---
			 X | O | O
			---|---|---
			 O | X | X
		]]
		local board = Board.fromPattern("OXXXOOOXX")

		local value = Computer.terminal(board)

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

		local value = Computer.terminal(board)

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

		local value = Computer.terminal(board)

		expect(value).to.equal(1)
	end)

	it("returns -1 for a board that player O won", function()
		--[[
			O--
			OXX
			O-X
		]]
		local board = Board.fromPattern("O,,OXXO,X")

		local value = Computer.terminal(board)

		expect(value).to.equal(-1)
	end)
end)

describe("Computer.resultOf #fuzz", function()
	for _ = 1, 50 do
		::start::
		local marks = { Mark.X, Mark.O, nil }
		local char = { "X", "O", "," }
		local patternList = {}
		local expected = {}
		local markPositions = {}
		for pos = 1, 9 do
			local choice = math.random(3)
			patternList[pos] = char[choice]
			expected[pos] = marks[choice]
			if choice == 3 then
				table.insert(markPositions, pos)
			end
		end
		if #markPositions == 0 then
			goto start
		end

		local pattern = table.concat(patternList)
		local chosenPos = markPositions[math.random(#markPositions)]
		local chosenMark = marks[math.random(2)]
		expected[chosenPos] = chosenMark
		local testName = string.format(
			"returns a new board (%s) with the given mark (%s) applied to (%s)",
			pattern,
			chosenMark,
			chosenPos
		)

		it(testName, function()
			local board = Board.fromPattern(pattern)

			local newBoard = Computer.resultOf(board, chosenMark, chosenPos)

			for i = 1, 9 do
				expect(expected[i]).to.equal(newBoard.board[i])
			end
		end)
	end
end)
