defmodule Users do
  def create(pid, socket, name) do
    user = %User{pid: pid, socket: socket, name: String.trim(name)}
  end

  def add(agent, new_user) do
    AppState.add(agent, :users, new_user)
  end

  def find_by_name(agent, name) do
    AppState.get(agent, :users)
    |> Enum.find(fn user -> user.name == name end)
  end

  def list(agent) do
    AppState.get(agent, :users)
  end
end
