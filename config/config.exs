use Mix.Config

config :chat_server, 
port: 8000

import_config "#{Mix.env()}.exs"
