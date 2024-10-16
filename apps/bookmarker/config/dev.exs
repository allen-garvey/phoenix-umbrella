import Config

Code.require_file("config.ex",  "#{__DIR__}/../../../lib/common/")

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :bookmarker, Bookmarker.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false


# Watch static and templates for browser reloading.
config :bookmarker, Bookmarker.Endpoint,
  live_reload: [
    patterns: [
      # ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/static/js/app\.js$},
      ~r{priv/static/css/app\.css$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
