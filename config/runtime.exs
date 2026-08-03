import Config

config :photog,
  image_url_prefix: "",
  image_thumbnails_only: System.get_env("UMBRELLA_PHOTOG_IMAGE_THUMBNAILS_ONLY", "0"),
  b2_bucket_prefix: System.get_env("UMBRELLA_PHOTOG_B2_BUCKET_PREFIX", ""),
  b2_application_key: System.get_env("UMBRELLA_PHOTOG_B2_APPLICATION_KEY", ""),
  thumbnail_source_path: System.get_env("UMBRELLA_PHOTOG_THUMBNAIL_SOURCE_PATH", ""),
  image_source_path: System.get_env("UMBRELLA_PHOTOG_IMAGE_SOURCE_PATH", "")
