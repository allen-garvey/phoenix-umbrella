# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

# General application configuration
config :photog,
  # ecto_repos: [Photog.Repo],
  image_url_prefix: System.get_env("UMBRELLA_PHOTOG_IMAGE_URL_PREFIX", "")

# Configures the endpoint
config :photog, PhotogWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6014],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: PhotogWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Photog.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :format_encoders, json: Jason
# config :photog, Photog.Repo,
#   types: Common.PostgrexTypes

# Configure your database
# config :photog, Photog.Repo, Umbrella.Common.Config.postgres_config("photog_dev")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
