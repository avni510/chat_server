defmodule UsersTest do
  use ExUnit.Case
  doctest Users

  setup do
    agent = AppState.init()
    %{agent: agent}
  end

  describe "create/3" do
    test "it creates a user" do
      pid = self()
      socket = "mock socket"
      name = "Test\r"

      user = Users.create(pid, socket, name)

      assert user.pid == pid
      assert user.socket == socket
      assert user.name == "Test"
    end
  end

  describe "add_user/2" do
    test "it adds a user to the state", %{agent: agent} do
      user = Users.create(self(), "mock socket", "Test")

      Users.add(agent, user)

      users = Users.list(agent)

      assert users == [user]
    end
  end

  describe "find_by_name/2" do
    test "it finds a user by their name", %{agent: agent} do
      user = Users.create(self(), "mock socket", "Test")
      Users.add(agent, user)

      found_user = Users.find_by_name(agent, "Test")

      assert found_user == user
    end
  end
end
