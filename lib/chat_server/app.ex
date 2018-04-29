defmodule ChatServer.App do
  def accept_connections(port) do
    {:ok, server_socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    IO.puts("Accepting connections on port #{port}") 
    loop_acceptor(server_socket)
  end

  defp loop_acceptor(server_socket) do
    {:ok, client_socket} = :gen_tcp.accept(server_socket)
    serve(client_socket)
    loop_acceptor(server_socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end

