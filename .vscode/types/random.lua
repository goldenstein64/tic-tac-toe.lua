---@meta

---the `lrandom` module
---@class lrandom
local lrandom = {}

---contains some info about the module
---@type string
lrandom.version = nil

---an instance of `lrandom`, containing state about the random number generator
---@class lrandom.Random : lrandom
---@overload fun(): number
---@overload fun(n: integer): integer
---@overload fun(m: integer, n: integer): integer

---creates a new random number generator
---@param seed? number
---@return lrandom.Random c
---@nodiscard
function lrandom.new(seed) end

---clones an existing random number generator
---@param c lrandom.Random
---@return lrandom.Random cNew
---@nodiscard
function lrandom.clone(c) end

---sets the seed on a random number generator
---@param c lrandom.Random
---@param seed? number
---@return lrandom.Random c
function lrandom.seed(c, seed) end

---generates a uniform random float in the range of [0, 1)
---@param c lrandom.Random
---@return number
function lrandom.value(c) end

---generates a uniform random integer in the range of [1, n]
---
---> **Note:** passing in floats does *not* return floats like
---> `math.random(n)`. `n` gets floored in this case.
---
---> **Note:** this function will not error when `n < 1`. Instead, 1 and `n`
---> will swap places.
---@param c lrandom.Random
---@param n integer
---@return integer
function lrandom.value(c, n) end

---generates a uniform random integer in the range of [m, n]
---
---> **Note:** passing in floats does *not* return floats like
---> `math.random(m, n)`. `m` gets ceiled and `n` gets floored in this case.
---
---> **Note:** this function will not error when `m > n`. Instead, `m` and `n`
---> will swap places.
---@param c lrandom.Random
---@param m integer
---@param n integer
---@return integer
function lrandom.value(c, m, n) end

lrandom.__call = lrandom.value
lrandom.__index = lrandom

return lrandom
