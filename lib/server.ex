defmodule Server do
  def serve(socket, room) do
    socket
    |> read_line()
    |> write_line(socket, room)

    serve(socket, room)
  end

  def send_to_socket(line, socket) do
    :gen_tcp.send(socket, line)
  end

  def read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
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
