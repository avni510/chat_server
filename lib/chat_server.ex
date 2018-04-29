defmodule ChatServer do
  def accept(port) do
    {:ok, server_socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    IO.puts "Accepting connections on port #{port}"
    agent = AppState.init()
    loop_acceptor(server_socket, agent)
  end

  defp loop_acceptor(server_socket, agent) do
    {:ok, client_socket} = :gen_tcp.accept(server_socket)
    spawn(fn -> chat_setup(client_socket, agent) end)
    loop_acceptor(server_socket, agent)
  end

  defp chat_setup(socket, agent) do
    sender = get_sender_name(socket, agent)
    receipent = get_receipent(socket)
    room = get_chat_room(agent, sender, receipent)

    Server.serve(sender.socket, room)
  end

  defp get_sender_name(socket, agent) do
    Server.send_to_socket("Hi, what's your name?\n", socket)
    name = Server.read_line(socket) |> String.trim
    agent
    |> Users.find_by_name(name)
    |> case do
      nil -> create_and_add_user(agent, socket, name)
    end
  end

  defp get_receipent(socket) do
    Server.send_to_socket("What user would you like to chat with?\n", socket)
    Server.read_line(socket) |> String.trim
  end

  defp get_chat_room(agent, sender, receipent) do
      agent
      |> ChatRooms.find_by_name("#{receipent}#{sender.name}")
      |> case do
        nil -> agent
                |> Users.find_by_name(receipent)
                |> case do
                  nil -> Server.send_to_socket("this user does not exist", sender.socket)
                  user ->
                    create_and_add_chat_room(
                      agent,
                      [sender, user],
                      "#{sender.name}#{user.name}"
                    )
                end
        room -> room
      end
  end

  defp create_and_add_user(agent, socket, name) do
    user = Users.create(self(), socket, name)
    Users.add(agent, user)
    user
  end

  defp create_and_add_chat_room(agent, users, name) do
    room = ChatRooms.create(users, name, [])
    ChatRooms.add(agent, room)
    room
  end
end
