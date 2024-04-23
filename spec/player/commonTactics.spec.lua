local Board = require("tic-tac-toe.data.Board")
local Mark = require("tic-tac-toe.data.Mark")

local METHOD_FORMAT = "%s:getMove"

local testTactics = {
	{ "detects winning moves for X", ",XX,OO,,,", Mark.X, { 1 } },
	{ "detects winning moves for O", ",OO,XX,,X", Mark.O, { 1 } },
	{ "detects blocking moves for X", "O,,O,X,X,", Mark.X, { 7 } },
	{ "detects blocking moves for O", ",O,X,,XXO", Mark.O, { 1 } },
	{ "detects trapping moves for X", ",X,O,X,O,", Mark.X, { 3 } },
	{ "detects trapping moves for O", ",X,OXX,O,", Mark.O, { 7 } },
	{ "matches ',XXXOOOX,'", ",XXXOOOX,", Mark.O, { 1 } },
}

---@param computerGen fun(): tic-tac-toe.Computer
---@param name string
local function testCommonTactics(computerGen, name)
	local computer ---@type tic-tac-toe.Computer
	before_each(function()
		computer = computerGen()
	end)

	describe(METHOD_FORMAT:format(name), function()
		for _, tactic in ipairs(testTactics) do
			---@type string, string, tic-tac-toe.Mark, integer
			local testName, pattern, mark, expected = table.unpack(tactic, 1, 4)
			it(testName, function()
				local board = Board.fromPattern(pattern)

				local move = computer:getMoves(board, mark)

				expect(move).to.look.like(expected)
			end)
		end
	end)
end

local random = require("random")
local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")

testCommonTactics(function()
	return MediumComputer(random.new())
end, "MediumComputer")
testCommonTactics(function()
	return HardComputer(random.new())
end, "HardComputer")
