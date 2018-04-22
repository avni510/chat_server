defmodule ChatRooms do
  def create(users, room_name, messages) do
    %ChatRoom{users: users, name: room_name, messages: messages}
  end

  def add(agent, new_room) do
    AppState.add(agent, :chat_rooms, new_room)
  end

  def find_by_name(agent, name) do
    AppState.get(agent, :chat_rooms)
    |> Enum.find(fn room -> room.name == name end)
  end

  def list(agent) do
    AppState.get(agent, :chat_rooms)
  end
end
