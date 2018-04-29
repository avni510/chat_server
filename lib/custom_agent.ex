defmodule CustomAgent do
  use GenServer

  ## Client


  def start_link(func) do
    GenServer.start_link(__MODULE__, func)
  end

  def update(agent, func) do
    GenServer.call(agent, {:update, func})
  end

  def get(agent, func) do
    GenServer.call(agent, {:get, func})
  end

  def cast(agent, func) do
    GenServer.cast(agent, {:cast, func})
  end


  ## Server

  def init(func) do
    {:ok, apply(func, [])}
  end

  def handle_call({:get, func}, _from, state) do
    {:reply, apply(func, [state]), state}
  end

  def handle_call({:update, func}, _from, state) do
    {:reply, :ok, apply(func, [state])}
  end

  def handle_cast({:cast, func}, state) do
    {:noreply, apply(func, [state])}
  end
end
