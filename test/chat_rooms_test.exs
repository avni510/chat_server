defmodule ChatRoomsTest do
  use ExUnit.Case

  setup do
    agent = AppState.init()
    %{agent: agent}
  end

  describe "create/3" do
    test "it creates a chat room", %{agent: agent} do
      user = Users.create(self(), "mock socket", "User A")
      message = Messages.create(user, "test message")

      room = ChatRooms.create([user], "new room", [message])

      assert room.users == [user]
      assert room.messages == [message]
      assert room.name == "new room"
    end
  end

  describe "add/2" do
    test "it adds a chat room", %{agent: agent} do
      user = Users.create(self(), "mock socket", "User A")
      message = Messages.create(user, "test message")
      room = ChatRooms.create([user], "new room", [message])

      ChatRooms.add(agent, room)

      rooms = ChatRooms.list(agent)

      assert rooms == [room]
    end
  end

  describe "find_by_name/2" do
    test "it finds a chat room by its name", %{agent: agent} do
      user = Users.create(self(), "mock socket", "User A")
      message = Messages.create(user, "test message")
      room = ChatRooms.create([user], "new room", [message])
      ChatRooms.add(agent, room)

      found_room = ChatRooms.find_by_name(agent, "new room")

      assert room == found_room
    end
  end
end
