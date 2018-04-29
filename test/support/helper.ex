defmodule Support.Helper do

  def clean_state(_) do
    Agent.update(ChatServer.State, fn state ->
      ChatServer.State.initial_state()
    end)
    :ok
  end
end
