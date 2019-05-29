defmodule ChatServer.Protocol.MockTcp do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 
      %{receiving_data: %{}, sending_data: %{}}
    end, 
    name: __MODULE__)
  end

  def listen(_) do
    {:ok, %{}}
  end

  def accept(_) do
    {:ok, %{}} 
  end

  def recv(_) do
    {:ok, get_receiving_message()}
  end

  def write(message, socket) do
    set_sending_data(socket, message)
    socket
  end

  def set_receiving_data(socket, message) do
    Agent.update(__MODULE__, fn data -> 
      Map.put(
        data, 
        :receiving_data, 
        %{socket: socket, message: message}
      )
    end)
  end

  def get_receiving_message do
    Agent.get(__MODULE__, fn data -> 
      data
      |> Map.get(:receiving_data)
      |> Map.get(:message)
    end)
  end

  def set_sending_data(socket, message) do
    Agent.update(__MODULE__, fn data -> 
      Map.put(
        data, 
        :sending_data, 
        %{socket: socket, message: message}
      )
    end)
  end

  def get_sending_data do
    Agent.get(__MODULE__, fn data -> 
      Map.get(data, :sending_data)
    end)
  end
end
