import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :seren, SerenWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Configure your database
# config :seren, Seren.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "seren_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
