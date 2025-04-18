import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blockquote, BlockquoteWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Configure your database
# config :blockquote, Blockquote.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "blockquote_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox
