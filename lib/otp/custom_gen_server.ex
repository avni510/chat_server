defmodule Otp.CustomGenServer do

  def start_link(module, args, name: name) do
    pid = spawn(__MODULE__, :server_init, [module, args])

    :ets.new(:names, [:set, :private, :named_table])
    :ets.insert(:names, {name, pid})

    {:ok, pid}
  end

  def server_init(module, args) do
    {:ok, state} = module.init(args)
    listen(module, state)
  end

  def call(server_pid, request) when is_pid(server_pid) do
    send(server_pid, {:call, self(), request})
    
    receive do
      {:response, response} -> response
    end
  end

  def call(name, request) do
    case :ets.lookup(:names, name) do
      [{_, pid}] -> call(pid, request)
      [] -> "not found"
    end
  end

  def cast(server_pid, request) when is_pid(server_pid) do
    send(server_pid, {:cast, self(), request})
  end

  def cast(name, request) do
    case :ets.lookup(:names, name) do
      [{_, pid}] -> cast(pid, request)
      [] -> "not found"
    end
  end

  defp listen(module, state) do
    receive do
      {:call, parent_pid, request} ->
        {:reply, response, new_state} = 
          module.handle_call(request, parent_pid, state)

        send(parent_pid, {:response, response})

        listen(module, new_state)

      {:cast, _, request} ->
        {:noreply, new_state} = 
          module.handle_cast(request, state)
        
        listen(module, new_state)
    end
  end
end
