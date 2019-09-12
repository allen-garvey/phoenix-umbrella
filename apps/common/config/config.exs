import Config


config :common,
  super_search_url: System.get_env("UMBRELLA_SUPER_SEARCH_URL", "http://search.alaska.test")
