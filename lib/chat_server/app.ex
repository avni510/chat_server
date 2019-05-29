defmodule ChatServer.App do
  @protocol Application.get_env(:chat_server, :protocol)

  alias ChatServer.Messenger

  def accept_connections(port) do
    {:ok, server_socket} = @protocol.listen(port) 
    loop_acceptor(server_socket)
  end

  defp loop_acceptor(server_socket) do
    {:ok, client_socket} = @protocol.accept(server_socket) 
    spawn(fn -> execute_chat(client_socket) end)

    loop_acceptor(server_socket)
  end

  defp serve(socket, sender) do
    socket
    |> Messenger.communicate(sender)
    |> serve(sender)
  end

  defp execute_chat(client_socket) do
    {:ok, sender} = Messenger.get_sender(client_socket)
    serve(client_socket, sender)
  end
end

