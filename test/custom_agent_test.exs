defmodule CustomAgentTest do
  use ExUnit.Case

  setup do
    {:ok, agent} = CustomAgent.start_link(fn -> %{names: ["Ringo"]} end)
    %{agent: agent}
  end

  describe "get/2" do
    test "it returns a value from the state", %{agent: agent} do
      value = CustomAgent.get(agent, fn state -> Map.get(state, :names) end)

      assert value == ["Ringo"]
    end
  end

  describe "update/2" do
    test "it updates a value in the state", %{agent: agent} do
      reply = CustomAgent.update(
        agent,
        fn state -> %{state | names: ["Ringo", "George"]} end
      )

      assert reply == :ok

      value = CustomAgent.get(agent, fn state -> Map.get(state, :names) end)
      assert value == ["Ringo", "George"]
    end
  end

  describe "cast/2" do
    test "it changes the state of the agent with no reply", %{agent: agent} do
      CustomAgent.cast(
        agent,
        fn state -> %{state | names: ["Ringo", "George"]} end
      )

      value = CustomAgent.get(agent, fn state -> Map.get(state, :names) end)
      assert value == ["Ringo", "George"]
    end
  end
end
