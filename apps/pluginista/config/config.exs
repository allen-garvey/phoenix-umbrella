# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

# config :pluginista,
#   ecto_repos: [Pluginista.Repo]

# Configures the endpoint
config :pluginista, PluginistaWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6018],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: PluginistaWeb.ErrorView, accepts: ~w(html json), layout: false]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
