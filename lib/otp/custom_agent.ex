defmodule Otp.CustomAgent do
  use GenServer

  # Client

  def start_link(func, name: name) do
    GenServer.start_link(__MODULE__, func, name: name)
  end

  # synchronous
  def update(agent, func) do
    GenServer.call(agent, {:update, func})
  end

  # synchronous
  def get(agent, func) do
    GenServer.call(agent, {:get, func})
  end

  # async
  def cast(agent, func) do
    GenServer.cast(agent, {:cast, func})
  end

  # Server

  def init(arg) do
    {:ok, arg}
  end
  
  def handle_call({:update, func}, _from, state) do
    {:reply, :ok, func.(state)}
  end

  def handle_call({:get, func}, _from, state) do
    {:reply, func.(state), state}
  end

  def handle_cast({:cast, func}, state) do
    {:noreply, func.(state)}
  end
end
