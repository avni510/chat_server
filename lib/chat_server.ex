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
    send_to_socket("Hi, what's your name?\n", socket)
    name = read_line(socket) |> String.trim
    sender =
      agent
      |> Users.find_by_name(name)
      |> case do
        nil -> create_and_add_user(agent, socket, name)
      end

    send_to_socket("What user would you like to chat with?\n", socket)
    username = read_line(socket) |> String.trim

    room =
      agent
      |> ChatRooms.find_by_name("#{username}#{sender.name}")
      |> case do
        nil -> agent
                |> Users.find_by_name(username)
                |> case do
                  nil -> send_to_socket("this user does not exist", sender.socket)
                  recipient ->
                    create_and_add_chat_room(
                      agent,
                      [sender, recipient],
                      "#{sender.name}#{recipient.name}"
                    )
                end
        room -> room
      end
    serve(sender.socket, room)
  end

  def create_and_add_user(agent, socket, name) do
    user = Users.create(self(), socket, name)
    Users.add(agent, user)
    user
  end

  def create_and_add_chat_room(agent, users, name) do
    room = ChatRooms.create(users, name, [])
    ChatRooms.add(agent, room)
    room
  end

  defp serve(socket, room) do
    socket
    |> read_line()
    |> write_line(socket, room)

    serve(socket, room)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp send_to_socket(line, socket) do
    :gen_tcp.send(socket, line)
  end

  defp write_line(line, socket, room) do
    broadcast(room, line, socket)
  end

  defp broadcast(room, line, socket) do
    sender =
      room.users
      |> Enum.filter(fn user -> user.socket == socket end)
      |> Enum.at(0)

    room.users
    |> List.delete(sender)
    |> Enum.map(fn user ->
      send_to_socket("#{sender.name}: #{line}", user.socket)
    end)
  end
end
