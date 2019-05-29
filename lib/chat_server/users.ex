defmodule ChatServer.User do
  defstruct name: nil, pid: nil, socket: nil
end


defmodule ChatServer.Users do
  alias ChatServer.User
  alias ChatServer.AppState

  def add(params) do
    user = struct(User, params)

    AppState.add(:users, user)

    {:ok, user}
  end

  def get(name) do
    users = AppState.get(:users)

    Enum.find(users, fn user -> user.name == name end)
  end

  def delete(name) do
    user = get(name)

    AppState.delete(:users, user)
  end

  def all do
    AppState.get(:users)
  end
end
