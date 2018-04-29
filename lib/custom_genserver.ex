defmodule CustomGenServer do
  @state %{state: ["Ringo"]}

  def listen(initial_state) do
    %{@state | state: initial_state}
    receive do
      message -> call(message)
    end
    listen(@state.state)
  end

  def call({:get, func}) do
    handle_call({:get, func}, self(), @state.state)
  end

  def call({:update, func}) do
    handle_call({:update, func}, self(), @state.state)
  end

  def cast(agent, {:cast, func}) do
    handle_cast({:cast, func}, @state.state)
  end


  defp handle_call({:get, func}, pid, state) do
    receive do
      {:get, func} ->
        send(pid, {:reply, apply(func, [state]), @state.state})
      _ -> IO.put("Invalid get match")
    end
  end

  defp handle_call({:update, func}, pid, state) do
    receive do
      {:update, func} ->
        send(pid, {:reply, :ok, apply(func, state)})
      _ -> IO.put("Invalid update match")
    end
  end

  defp handle_cast({:cast, func}, state) do
    {:noreply}
  end
end
