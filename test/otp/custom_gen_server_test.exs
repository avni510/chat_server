defmodule Otp.CustomGenServerTest do
  use ExUnit.Case

  alias Otp.CustomGenServer

  setup do
    CustomGenServer.start_link(__MODULE__, [], name: __MODULE__)
    :ok
  end

  def init(args) do
    {:ok, args}
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

  describe "call/2" do
    test "it makes a synchronous call to the server" do
      CustomGenServer.call(__MODULE__, {:update, fn _ -> [1] end})

      state = CustomGenServer.call(__MODULE__, {:get, fn x -> x end})

      assert state == [1] 
    end
  end

  describe "cast/2" do
    test "it makes an async call to the server" do
      CustomGenServer.cast(__MODULE__, {:cast, fn _ -> [1] end})

      state = CustomGenServer.call(__MODULE__, {:get, fn x -> x end})

      assert state == [1] 
    end
  end
end
