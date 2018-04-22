defmodule Messages do
  def create(user, text) do
    %Message{user: user, text: text}
  end
end
