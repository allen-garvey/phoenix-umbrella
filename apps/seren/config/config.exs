# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

# General application configuration
# config :seren,
#   ecto_repos: [Seren.Repo]

# Configures the endpoint
config :seren, SerenWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6013],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: SerenWeb.ErrorView, accepts: ~w(html json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders, json: Jason
# config :seren, Seren.Repo,
#   types: Common.PostgrexTypes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
