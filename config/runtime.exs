import Config

Code.require_file("config.ex", "#{__DIR__}/../lib/common/")

# Grenadier
config :grenadier, GrenadierWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6009],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: GrenadierWeb.ErrorView, accepts: ~w(html json)]

config :grenadier, Grenadier.Repo,
  username: "postgres",
  password: "postgres",
  database: "umbrella",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  port: System.get_env("UMBRELLA_DB_PORT", "5432"),
  pool_size: 10,
  queue_target: 5000

# Artour
config :artour, Artour.Endpoint,
  url: [host: "localhost"],
  http: [port: 6010],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: Artour.ErrorView, accepts: ~w(html json)]

# BlockQuote
config :blockquote, BlockquoteWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6011],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: BlockquoteWeb.ErrorView, accepts: ~w(html json)]

# Booklist
config :booklist, BooklistWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6015],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: BooklistWeb.ErrorView, accepts: ~w(html json)]

# Bookmarker
config :bookmarker, Bookmarker.Endpoint,
  url: [host: "localhost"],
  http: [port: 6016],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: Bookmarker.ErrorView, accepts: ~w(html json)]

# Common
config :common,
  super_search_url: System.get_env("UMBRELLA_SUPER_SEARCH_URL", "http://search.alaska.test")

# Habits
config :habits, HabitsWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6019],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: HabitsWeb.ErrorView, accepts: ~w(html json), layout: false]

# Movielist
config :movielist, MovielistWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6012],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: MovielistWeb.ErrorView, accepts: ~w(html json)]

# Photog
config :photog, PhotogWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6014],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: PhotogWeb.ErrorView, accepts: ~w(html json)]

config :photog,
  image_url_prefix: "",
  image_thumbnails_only: System.get_env("UMBRELLA_PHOTOG_IMAGE_THUMBNAILS_ONLY", "0"),
  b2_bucket_prefix: System.get_env("UMBRELLA_PHOTOG_B2_BUCKET_PREFIX", ""),
  b2_application_key: System.get_env("UMBRELLA_PHOTOG_B2_APPLICATION_KEY", ""),
  thumbnail_source_path: System.get_env("UMBRELLA_PHOTOG_THUMBNAIL_SOURCE_PATH", ""),
  image_source_path: System.get_env("UMBRELLA_PHOTOG_IMAGE_SOURCE_PATH", "")

# Pluginista
config :pluginista, PluginistaWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6018],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: PluginistaWeb.ErrorView, accepts: ~w(html json), layout: false]

# Seren
config :seren, SerenWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6013],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: SerenWeb.ErrorView, accepts: ~w(html json)]

# Startpage
config :startpage, StartpageWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 6017],
  secret_key_base: Umbrella.Common.Config.secret_key_base(),
  render_errors: [view: StartpageWeb.ErrorView, accepts: ~w(html json)]
