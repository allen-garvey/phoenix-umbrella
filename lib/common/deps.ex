defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_pubsub, "~> 2.0"},
      ecto(),
      {:ecto_sql, "~> 3.5.3"},
      {:postgrex, "~> 0.15"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.3.0", only: :dev},
      {:gettext, "~> 0.17.1"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.4.0"},
      {:common, in_umbrella: true},
      {:assertions, "~> 0.15", only: :test},
    ]
  end

  def shared_authenticated_phoenix_deps do
    shared_phoenix_deps() ++
    [
      {:grenadier, in_umbrella: true},
    ]
  end

  def ecto do
    {:phoenix_ecto, "~> 4.2.1"}
  end

  def http_poison do
    {:httpoison, "~> 1.8.0"}
  end

  def floki do
    {:floki, "~> 0.29.0"}
  end

  def earmark do
    {:earmark, "~> 1.4.9"}
  end

  def argon2 do
    {:argon2_elixir, "~> 2.3.0"}
  end
end
