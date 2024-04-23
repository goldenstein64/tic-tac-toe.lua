local Board = require("tic-tac-toe.data.Board")
local Mark = require("tic-tac-toe.data.Mark")
local HardComputer = require("tic-tac-toe.player.HardComputer")

describe("HardComputer", function()
	it("implements Player", function()
		expect(HardComputer.getMove).to.be.a("function")
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

describe("Computer.resultOf", function()
	local marks = { Mark.X, Mark.O, nil }

	---@type fun(amount: number): fun(): (integer, (tic-tac-toe.Mark?)[], number[])
	local function generateBoard(amount)
		return coroutine.wrap(function()
			for i = 1, amount do
				---@type (tic-tac-toe.Mark?)[], number[]
				local expected, markPositions
				repeat
					expected = {}
					markPositions = {}
					for pos = 1, 9 do
						local choice = math.random(3)
						expected[pos] = marks[choice]
						if choice == 3 then
							table.insert(markPositions, pos)
						end
					end
				until #markPositions > 0

				coroutine.yield(i, expected, markPositions)
			end
		end)
	end

	for i, expected, markPositions in generateBoard(50) do
		local testName = string.format("gets calculated correctly (%d)", i)
		it(testName, function()
			local board = Board()
			board.board = table.move(expected, 1, 9, 1, {})

			local chosenPos = markPositions[math.random(#markPositions)]
			local chosenMark = marks[math.random(2)]
			expected[chosenPos] = chosenMark

			local newBoard = HardComputer.resultOf(board, chosenMark, chosenPos)

			for j = 1, 9 do
				expect(expected[j]).to.equal(newBoard.board[j])
			end
		end)
	end
end)
