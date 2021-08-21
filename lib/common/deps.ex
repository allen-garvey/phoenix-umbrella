defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    [
      {:phoenix, "~> 1.5.11"},
      {:phoenix_pubsub, "~> 2.0"},
      ecto(),
      {:ecto_sql, "~> 3.7.0"},
      {:postgrex, "~> 0.15.10"},
      {:phoenix_html, "~> 3.0.2"},
      {:phoenix_live_reload, "~> 1.3.3", only: :dev},
      {:gettext, "~> 0.17.1"},
      {:jason, "~> 1.2.2"},
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
    {:phoenix_ecto, "~> 4.4.0"}
  end

  def http_poison do
    {:httpoison, "~> 1.8.0"}
  end

  def floki do
    {:floki, "~> 0.31.0"}
  end

  def earmark do
    {:earmark, "~> 1.4.15"}
  end

  def argon2 do
    {:argon2_elixir, "~> 2.4.0"}
  end
end
