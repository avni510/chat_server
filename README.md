# ChatServer

This is miniature terminal chat app written in Elixir using the TCP protocol.

# Requirements

* elixir `~> 1.8.1`
* Install telnet with `brew install telnet`

# Usage

* Run the chat server with `mix run`. It will run on port 8000
* Connect to the chat server with `telnet 127.0.0.1 8000`

** Please note multiple terminal sessions should connect to the chat server in order to display the full functionality
of the app

# Tests
* `mix test`
