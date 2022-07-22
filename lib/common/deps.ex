defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    ecto() ++
    [
      {:phoenix, "~> 1.6.11"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 3.2.0"},
      {:phoenix_live_reload, "~> 1.3.3", only: :dev},
      {:gettext, "~> 0.17.1"},
      {:jason, "~> 1.3.0"},
      {:plug_cowboy, "~> 2.5.1"},
      {:common, in_umbrella: true},
      {:assertions, "~> 0.18.1", only: :test},
    ]
  end

  def shared_authenticated_phoenix_deps do
    shared_phoenix_deps() ++
    [
      {:grenadier, in_umbrella: true},
    ]
  end

  def ecto do
    [
      {:phoenix_ecto, "~> 4.4.0"},
      {:ecto_sql, "~> 3.8.3"},
      {:postgrex, "~> 0.16.3"},
    ]
  end

  def http_poison do
    {:httpoison, "~> 1.8.1"}
  end

  def floki do
    {:floki, "~> 0.33.1"}
  end

  def earmark do
    {:earmark, "~> 1.4.26"}
  end

  def argon2 do
    {:argon2_elixir, "~> 3.0.0"}
  end
end
