local random = require("random")

local MediumComputer = require("tic-tac-toe.player.MediumComputer")
local HardComputer = require("tic-tac-toe.player.HardComputer")
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

local testSubjects = {
	{
		name = "MediumComputer",
		gen = function()
			return MediumComputer(random.new())
		end,
	},
	{
		name = "HardComputer",
		gen = function()
			return HardComputer(random.new())
		end,
	},
}

for _, subject in ipairs(testSubjects) do
	local name, genComputer = subject.name, subject.gen
	describe(METHOD_FORMAT:format(name), function()
		for _, tactic in ipairs(testTactics) do
			---@type string, string, tic-tac-toe.Mark, number[]
			local testName, pattern, mark, expected = table.unpack(tactic, 1, 4) ---@diagnostic disable-line:assign-type-mismatch
			it(testName, function()
				local board = Board.fromPattern(pattern)

				local move = genComputer():getMoves(board, mark)

				expect(move).to.look.like(expected)
			end)
		end
	end)
end
