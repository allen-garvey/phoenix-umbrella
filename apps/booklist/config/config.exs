# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

config :booklist,
  ecto_repos: [Booklist.Repo]

# Configures the endpoint
config :booklist, BooklistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: BooklistWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Booklist.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason
config :booklist, Booklist.Repo,
  types: Common.PostgrexTypes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
