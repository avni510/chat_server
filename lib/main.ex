defmodule Main do
  use Application

  def start(_type, _args) do
    ChatServer.accept(8000)
  end
end
