# tic-tac-toe-lua

This is an implementation of tic-tac-toe in Lua. It's separated into two "packages," a library and a console application.

## tic-tac-toe Library

The library defines several datatypes and player behaviors. It also defines an `App` class that describes the general behavior for playing the game. All of its types can be found as LuaLS type definitions under the `tic-tac-toe.*` namespace.

## `class App`

Defines the behavior of a typical tic-tac-toe application. It creates its own `Board` internally and contains convenience methods for picking players from I/O (`:promptPlayers`, `:promptPlayer`), displaying the winner to I/O(`:displayWinner`), and playing the game (`:playGame`, `:playTurn`).

### `interface Connection`

A `Connection` represents an I/O interface. In this repo, it represents a console, but it can also represent a web interface, GUI, or other things.

The `Connection` interface defines two methods:
- `print(Message, ...args)`
- `prompt(Message, ...args): string`

`print` is like the `print` global, except it runs through an abstraction layer to format the `Message` into something a user may read.

`prompt` is like the `print` method, except it waits for a string of input after printing the `Message`. After receiving this input, it returns to the application, where it will do some validation. If something goes wrong during validation, it will call `print` with an error message and try again.

The actual `Message`s are strings that are meant to be handled by an implementation of `Connection`. So far, there are eleven in total:

```lua
-- tic-tac-toe/data/Message.lua

---@alias tic-tac-toe.Message
---| "app.msg.pickPlayer" -- , Mark
---| "app.msg.pickComputer" -- , Mark
---| "app.msg.game" -- , Board
---| "app.msg.playerWon" -- , Mark
---| "app.msg.tied"
---| "app.err.invalidPlayer" -- , input: string
---| "app.err.invalidComputer" -- , input: string
---| "human.msg.pickMove" -- , Mark
---| "human.err.NaN" -- , input: string
---| "human.err.outOfRange" -- , choice: integer
---| "human.err.occupied" -- , choice: integer
```

`tic-tac-toe-console` implements `Connection` using the `ConsoleConnection` class.

### `interface Player`

The `Player` interface defines one method: `getMove(Board, Mark): number`. The player gets the current state of the board and the mark they are playing as, and they return a number indicating which position on the board they want to place their mark on.

There are four implementations of the `Player` interface:
- `Human` - gets input from the I/O connection
- `EasyComputer` - picks an open slot on the board at random
- `MediumComputer` - picks a slot on the board using an ordered list of basic "move getters"
- `HardComputer` - directly implements the Minimax algorithm for optimal play

### `enum Mark`

There are two marks, `X` and `O`, and no others. These are instances of a class, not strings. They have an `:other()` method to get the other mark.

### `class Board`

Stores data pertaining to the board's state and contains methods for determining whether the board is in an end state (`:full()`, `:won(Mark)`) and inspecting/modifying the internal data structure (`:canMark()`, `:isMarkedWith()`, `:setMark()`). Its `data` property is also simply available.

You can instantiate the board with a predefined state using `Board.fromPattern`. It accepts a 9-byte string containing `'X'`, `'O'`, and a filler like `','`.

## tic-tac-toe-console Application

This program defines how to run a console application using its accompanying `ConsoleConnection` implementation and an instance of the library's `App`.

```lua
local conn = ConsoleConnection()
local app = App(conn)

local players = app:promptPlayers()
local winner = app:playGame(players)
app:displayWinner(winner)
```