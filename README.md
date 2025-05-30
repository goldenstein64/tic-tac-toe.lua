# tic-tac-toe.lua

This is an implementation of tic-tac-toe in Lua. You can view information about this project's design and completion in [tic-tac-toe.spec](https://github.com/goldenstein64/tic-tac-toe.spec).

## Setup

This project uses a LuaRocks for setup and can be run with any Lua runtime.

```shell
# clone the repository
git clone https://github.com/goldenstein64/tic-tac-toe.lua

# move into the directory
cd tic-tac-toe.lua

# initialize dependencies with LuaRocks
luarocks init
luarocks install --deps-only ./rockspec/tic-tac-toe-1.0.0-1.rockspec
```

## Usage

```shell
# run the console app
lua ./tic-tac-toe-console/init.lua

# test it
luarocks test # or 'busted'
```

## Publishing

```shell
luarocks upload ./rockspec/tic-tac-toe-1.0.0-1.rockspec
luarocks upload ./rockspec/tic-tac-toe-console-1.0.0-1.rockspec
```