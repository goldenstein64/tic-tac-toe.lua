---@meta

---@class luassert.internal
local luassert = {}

---asserts that the given `MockIO` object printed the given content.
---@param content string
---@param io tic-tac-toe.MockConnection
---@param message? string
---@return luassert.internal
function luassert.print(content, io, message) end

luassert.does_print = luassert.print
luassert.prints = luassert.print

---@class bustez.Expectation
local expect = {}

---asserts that our expectation, a `MockIO` object, printed the given content.
---@param content tic-tac-toe.Message
---@param message? string
---@return bustez.Expectation
function expect.print(content, message) end

expect.prints = expect.print
expect.to_print = expect.print
