defmodule ChatServer.MessengerTest do
  use ExUnit.Case

  alias ChatServer.Protocol.MockTcp
  alias ChatServer.Users
  alias ChatServer.Messenger
  import Support.Helper

  setup do
    reset_state([])
    MockTcp.start_link([])
    :ok
  end

  describe "get_sender/1" do
    test "it creates a user" do
      socket = "New Socket"
      MockTcp.set_receiving_data(socket, "Avni")

      Messenger.get_sender(socket)

      user = Users.get("Avni")

      assert user.name == "Avni"
      assert user.pid
      assert user.socket
    end
  end

  describe "communicate/2" do
    test "it sends the sender's message to other users" do
      {:ok, sender} = Users.add(%{name: "User 1", pid: self(), socket: "User 1 Socket"})
      Users.add(%{name: "User 2", pid: spawn(fn -> "test" end), socket: "User 2 Socket"})
      MockTcp.set_receiving_data(sender.socket, "Hello World")

      Messenger.communicate(sender.socket, sender)

      assert MockTcp.get_sending_data.socket == "User 2 Socket"
      assert MockTcp.get_sending_data.message =~ "Hello World"
    end
  end
end
