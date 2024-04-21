# tic-tac-toe-lua

This is an implementation of tic-tac-toe in Lua. It provides multiple features at the user level:

- By default, it is a console application.
- Each player in the game can either be a human or one of three difficulties of computers.
- Helper functions are provided for

## Data

There are three types of data exchanged between the application and the players:

- `Mark`: represents a player's symbol, X's and O's
- `Board`: represents the current game state, made up of `Mark`s and `nil`s
- `Move`: a number indicating which position on the board the player chose to place a mark on

The primary type of data exchanged between the application and the I/O interface is a `Message`, which is an enumeration of all requests and responses the user might see.

All data can be serialized into a string

## Behavior

- `App`: the top-level library component responsible for running the gameplay loop
- `Player`: an interface that describes how the application communicates with its player
