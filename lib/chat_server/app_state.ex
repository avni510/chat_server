defmodule ChatServer.AppState do
  alias Otp.CustomAgent
  
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(_) do
    CustomAgent.start_link(fn -> initial_state() end, name: __MODULE__)  
  end

  def initial_state do
    %{users: []}
  end

  def add(key, element) do
    CustomAgent.update(__MODULE__, fn state -> 
      value = Map.get(state, key)
      Map.put(state, key, value ++ [element]) 
    end)
  end

  def get(key) do
    CustomAgent.get(__MODULE__, fn state -> Map.get(state, key) end)
  end

  def delete(key, element) do
    CustomAgent.update(__MODULE__, fn state -> 
      new_value = 
        state
        |> Map.get(key)
        |> List.delete(element)

      Map.put(state, key, new_value) 
    end)
  end
end
