defmodule ChatServer.UsersTest do
  use ExUnit.Case

  alias ChatServer.Users
  import Support.Helper

  setup :reset_state

  describe "get/1" do
    test "given a name it returns a user" do
      {:ok, user} = Users.add(%{name: "test", pid: 123, socket: nil})

      found_user = Users.get("test")

      assert found_user == user
    end
  end

  describe "delete/1" do
    test "it deletes a user given a name" do
      {:ok, user} = Users.add(%{name: "test", pid: 123, socket: nil})

      Users.delete(user.name)

      refute Users.get(user.name)
    end
  end
end
