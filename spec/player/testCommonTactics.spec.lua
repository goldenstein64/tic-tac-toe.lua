local Board = require("tic-tac-toe.board.Board")
local Mark = require("tic-tac-toe.board.Mark")

local METHOD_FORMAT = "%s.getMove"

---@param cls Player
---@param name string
local function testCommonTactics(cls, name)
	describe(METHOD_FORMAT:format(name), function()
		it("can detect winning moves for X", function()
			--[[
				 1 | X | X
				---|---|---
				 4 | O | O
				---|---|---
				 7 | 8 | 9
			]]
			local board = Board.fromPattern(",XX,OO,,,")

			local move = cls.getMove(board, Mark.X)

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

			local move = cls.getMove(board, Mark.O)

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

			local move = cls.getMove(board, Mark.X)

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

			local move = cls.getMove(board, Mark.O)

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

			local move = cls.getMove(board, Mark.X)

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

			local move = cls.getMove(board, Mark.O)

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

			local move = cls.getMove(board, Mark.O)

			expect(move).to.equal(1)
		end)
	end)
end

local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")

testCommonTactics(MediumComputer, "MediumComputer")
testCommonTactics(HardComputer, "HardComputer")
