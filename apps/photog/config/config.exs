# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

# General application configuration
config :photog,
  ecto_repos: [Photog.Repo]

# Configures the endpoint
config :photog, PhotogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: PhotogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Photog.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
