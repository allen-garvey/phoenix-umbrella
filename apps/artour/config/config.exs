# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :artour,
  ecto_repos: [Artour.Repo]

# Configures the endpoint
config :artour, Artour.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HFASDja/QLCC9Tv9sreLiCsB1FfJaNswgMnhkYWckyZo2Wo/JtselfjNDteA4v5v",
  render_errors: [view: Artour.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Artour.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
