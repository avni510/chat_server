defmodule ChatServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_server,
      version: "0.1.0",
      elixir: "~> 1.8.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ChatServer, []}
    ]
  end
 
  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps, do: [] 
end
