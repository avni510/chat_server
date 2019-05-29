defmodule Support.Helper do

  def reset_state(_) do
    Agent.update(ChatServer.AppState, fn _ ->
      ChatServer.AppState.initial_state()
    end)
    :ok
  end
end
