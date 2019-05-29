defmodule ChatServer.Protocol.Tcp do
  def listen(port) do
    {:ok, server_socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    IO.puts("Accepting connections on port #{port}") 
    {:ok, server_socket}
  end

  def accept(server_socket) do
    :gen_tcp.accept(server_socket)
  end

  def recv(client_socket) do
    :gen_tcp.recv(client_socket, 0)
  end

  def write(line, client_socket) do
    :gen_tcp.send(client_socket, line)
  end
end
