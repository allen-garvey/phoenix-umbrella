# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

config :grenadier,
  ecto_repos: [Grenadier.Repo]

# Configures the endpoint
config :grenadier, GrenadierWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: Umbrella.Common.Config.grenadier_port()],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: GrenadierWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Grenadier.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason
config :grenadier, Grenadier.Repo,
  types: Common.PostgrexTypes

# Configure your database
config :grenadier, Grenadier.Repo, Umbrella.Common.Config.postgres_config("umbrella")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
