defmodule ChatServer.User do
  defstruct name: nil, pid: nil, socket: nil
end


defmodule ChatServer.Users do
  alias ChatServer.User
  alias ChatServer.State

  def add(params) do
    user = struct(User, params)

    State.add(:users, user)

    {:ok, user}
  end

  def get(name) do
    users = State.get(:users)

    Enum.find(users, fn user -> user.name == name end)
  end

  def delete(name) do
    user = get(name)

    State.delete(:users, user)
  end
end
