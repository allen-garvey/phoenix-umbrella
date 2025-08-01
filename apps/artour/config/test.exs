import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :artour, Artour.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Configure your database
config :artour, ecto_repos: [Grenadier.Repo]
# config :artour, Artour.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "artour_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
