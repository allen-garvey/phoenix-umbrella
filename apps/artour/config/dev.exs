import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :artour, Artour.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false #,
  # watchers: [npm: ["run", "watch"]]


# Watch static and templates for browser reloading.
config :artour, Artour.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
