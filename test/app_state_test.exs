defmodule AppStateTest do
  use ExUnit.Case

  test "it adds and gets a key in the state" do
    agent = AppState.init()
    user = Users.create(self(), "mock socket", "test")

    AppState.add(agent, :users, user)

    value = AppState.get(agent, :users)
    assert value == [user]
  end
end
