import Config

config :photog,
  thumbnail_source_path: System.get_env("UMBRELLA_PHOTOG_THUMBNAIL_SOURCE_PATH", ""),
  image_source_path: System.get_env("UMBRELLA_PHOTOG_IMAGE_SOURCE_PATH", "")
