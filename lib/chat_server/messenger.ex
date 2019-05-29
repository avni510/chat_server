defmodule ChatServer.Messenger do
  @protocol Application.get_env(:chat_server, :protocol)

  alias ChatServer.Users

  def get_sender(socket) do
    name = 
      socket
      |> write_line("Welcome! Please enter your name:\n")
      |> read_line()
      |> String.trim()

      socket
      |> write_line("Please enter your messages below:\n")

    Users.add(%{name: name, pid: self(), socket: socket})
  end

  def communicate(socket, sender) do
    message = read_line(socket)

    broadcast(sender, message)

    socket
  end

  defp broadcast(sender, message) do
    Users.all()
    |> Enum.filter(fn user -> user != sender end)
    |> Enum.map(fn user ->
      write_line(user.socket, "\n#{sender.name}: #{message}")
    end)
  end

  defp read_line(socket) do
    {:ok, data} = @protocol.recv(socket) 
    data
  end

  defp write_line(socket, line) do
    @protocol.write(line, socket)
    socket
  end
end
