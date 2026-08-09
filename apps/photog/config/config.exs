# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

Code.require_file("config.ex", "#{__DIR__}/../../../lib/common/")

# General application configuration
# config :photog,
#   # ecto_repos: [Photog.Repo],

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :format_encoders, json: Jason
# config :photog, Photog.Repo,
#   types: Common.PostgrexTypes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
