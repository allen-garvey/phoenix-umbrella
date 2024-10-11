# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

#config :habits,
  #ecto_repos: [Habits.Repo]

# Configures the endpoint
config :habits, HabitsWeb.Endpoint,
  url: [host: "localhost"],
  http: [ip: {127, 0, 0, 1}, port: 6019],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: HabitsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Habits.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure your database
# config :habits, Habits.Repo, Umbrella.Common.Config.postgres_config("habits_dev")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
