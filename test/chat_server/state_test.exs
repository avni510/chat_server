defmodule ChatServer.StateTest do
  use ExUnit.Case

  alias ChatServer.State
  alias ChatServer.User
  import Support.Helper

  setup :clean_state

  describe "get/1" do
    test "it returns all the values for a given key" do
      user = %User{name: "test", pid: 123}
      State.add(:users, user)

      users = State.get(:users)

      assert users == [user]
    end
  end

  describe "delete/2" do
    test "it deletes a given element" do
      user = %User{name: "test", pid: 123}
      State.add(:users, user)

      State.delete(:users, user)

      assert State.get(:users) == []
    end
  end
end
