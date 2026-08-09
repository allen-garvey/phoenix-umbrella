import Config

Code.require_file("config.ex", "#{__DIR__}/../lib/common/")

# Grenadier
config :grenadier, GrenadierWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: Umbrella.Common.Config.grenadier_port()],
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

# Common

config :common,
  super_search_url: System.get_env("UMBRELLA_SUPER_SEARCH_URL", "http://search.alaska.test")

# Photog
config :photog,
  image_url_prefix: "",
  image_thumbnails_only: System.get_env("UMBRELLA_PHOTOG_IMAGE_THUMBNAILS_ONLY", "0"),
  b2_bucket_prefix: System.get_env("UMBRELLA_PHOTOG_B2_BUCKET_PREFIX", ""),
  b2_application_key: System.get_env("UMBRELLA_PHOTOG_B2_APPLICATION_KEY", ""),
  thumbnail_source_path: System.get_env("UMBRELLA_PHOTOG_THUMBNAIL_SOURCE_PATH", ""),
  image_source_path: System.get_env("UMBRELLA_PHOTOG_IMAGE_SOURCE_PATH", "")
