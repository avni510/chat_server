defmodule Otp.CustomAgentTest do
  use ExUnit.Case

  alias Otp.CustomAgent

  setup do
    {:ok, agent} = CustomAgent.start_link(fn -> [] end, name: __MODULE__)

    %{agent: agent}
  end

  describe "update/2" do
    test "it updates the state synchronously", %{agent: agent} do
      :ok = CustomAgent.update(agent, fn _ -> [1] end)

      state = CustomAgent.get(agent, &(&1))
      
      assert state == [1]
    end
  end

  describe "cast/2" do
    test "it updates the state async", %{agent: agent} do
      CustomAgent.cast(agent, fn _ -> [1] end)

      state = CustomAgent.get(agent, &(&1))
      
      assert state == [1]
    end
  end
end
