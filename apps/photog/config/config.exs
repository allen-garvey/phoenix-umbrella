# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :photog,
  ecto_repos: [Photog.Repo]

# Configures the endpoint
config :photog, PhotogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ml22C48NmRSK+oG0JxrGewaqVbjVJSpVDMMwy7jYo/sZmgUWjP7S39vPLfr90sae",
  render_errors: [view: PhotogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Photog.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
