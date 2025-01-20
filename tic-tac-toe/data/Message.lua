---@meta

---@alias tic-tac-toe.Message
---| "app.msg.pickPlayer" -- (Mark)
---| "app.msg.pickComputer" -- (Mark)
---| "app.msg.game" -- (board: string)
---| "app.msg.playerWon" -- (Mark)
---| "app.msg.tied"
---| "app.err.invalidPlayer" -- (input: string)
---| "app.err.invalidComputer" -- (input: string)
---| "human.msg.pickMove" -- (Mark)
---| "human.err.NaN" -- (input: string)
---| "human.err.outOfRange" -- (choice: number)
---| "human.err.occupied" -- (choice: number)

---@class tic-tac-toe.Connection
local Connection = {}

---@overload fun(self, msg: "app.msg.pickPlayer", mark: tic-tac-toe.Mark)
---@overload fun(self, msg: "app.msg.pickComputer", mark: tic-tac-toe.Mark)
---@overload fun(self, msg: "app.msg.game", board: string)
---@overload fun(self, msg: "app.msg.playerWon", mark: tic-tac-toe.Mark)
---@overload fun(self, msg: "app.msg.tied")
---@overload fun(self, msg: "app.err.invalidPlayer", input: string)
---@overload fun(self, msg: "app.err.invalidComputer", input: string)
---@overload fun(self, msg: "human.msg.pickMove", mark: tic-tac-toe.Mark)
---@overload fun(self, msg: "human.err.NaN", input: string)
---@overload fun(self, msg: "human.err.outOfRange", choice: number)
---@overload fun(self, msg: "human.err.occupied", choice: number)
function Connection:print(msg, choice) end

---@overload fun(self, msg: "app.msg.pickPlayer", mark: tic-tac-toe.Mark): string
---@overload fun(self, msg: "app.msg.pickComputer", mark: tic-tac-toe.Mark): string
---@overload fun(self, msg: "app.msg.game", board: string): string
---@overload fun(self, msg: "app.msg.playerWon", mark: tic-tac-toe.Mark): string
---@overload fun(self, msg: "app.msg.tied"): string
---@overload fun(self, msg: "app.err.invalidPlayer", input: string): string
---@overload fun(self, msg: "app.err.invalidComputer", input: string): string
---@overload fun(self, msg: "human.msg.pickMove", mark: tic-tac-toe.Mark): string
---@overload fun(self, msg: "human.err.NaN", input: string): string
---@overload fun(self, msg: "human.err.outOfRange", choice: number): string
---@overload fun(self, msg: "human.err.occupied", choice: number): string
function Connection:prompt(msg, ...) end
