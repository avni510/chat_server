defmodule ChatServer.AppStateTest do
  use ExUnit.Case

  alias ChatServer.AppState
  alias ChatServer.User
  import Support.Helper

  setup :reset_state

  describe "get/1" do
    test "it returns all the values for a given key" do
      user = %User{name: "test", pid: 123}
      AppState.add(:users, user)

      users = AppState.get(:users)

      assert users == [user]
    end
  end

  describe "delete/2" do
    test "it deletes a given element" do
      user = %User{name: "test", pid: 123}
      AppState.add(:users, user)

      AppState.delete(:users, user)

      assert AppState.get(:users) == []
    end
  end
end
