defmodule ChatServer do
  use Application

  alias ChatServer.App

  def start(_type, _args) do
    [ChatServer.AppState]
    |> Supervisor.start_link(strategy: :one_for_one)
    |> start_server(Mix.env())
  end

  def start_server(supervisor, :test) do
    supervisor
  end

  def start_server(_, :dev) do
    :chat_server
    |> Application.fetch_env!(:port)
    |> App.accept_connections()
  end
end
