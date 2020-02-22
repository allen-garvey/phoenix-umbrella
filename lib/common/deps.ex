defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    [
      {:phoenix, "~> 1.4.14"},
      {:phoenix_pubsub, "~> 1.1"},
      ecto(),
      {:ecto_sql, "~> 3.3.4"},
      {:postgrex, "~> 0.15"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.17.1"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.1.2"},
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
    {:phoenix_ecto, "~> 4.1"}
  end

  def http_poison do
    {:httpoison, "~> 1.6.2"}
  end

  def floki do
    {:floki, "~> 0.26.0"}
  end

  def earmark do
    {:earmark, "~> 1.4.3"}
  end

  def argon2 do
    {:argon2_elixir, "~> 2.2.1"}
  end
end
