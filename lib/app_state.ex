defmodule AppState do
  def init do
    {:ok, agent} = Agent.start_link(fn ->
      %State{users: [], chat_rooms: []}
    end)
    agent
  end

  def add(agent, key, new_value) do
    Agent.update(agent, fn state ->
      Map.update!(state, key, fn value ->
        [new_value | value]
      end)
    end)
  end

  def get(agent, key) do
    Agent.get(agent, fn state -> Map.get(state, key) end)
  end
end
