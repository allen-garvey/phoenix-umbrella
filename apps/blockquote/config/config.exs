# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blockquote,
  ecto_repos: [Blockquote.Repo]

# Configures the endpoint
config :blockquote, BlockquoteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cStnbGPZ8ZhXtVZvtEk51G6zVlfmX/5IpXlbchGmaqRPF2RCbP3VUNVurom5R3Vs",
  render_errors: [view: BlockquoteWeb.ErrorView, accepts: ~w(html json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
