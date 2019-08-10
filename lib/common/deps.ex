defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      ecto(),
      {:ecto_sql, "~> 3.1.6"},
      {:postgrex, "~> 0.15"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.16"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.1"},
      {:common, in_umbrella: true},
    ]
  end

  def shared_authenticated_phoenix_deps do
    shared_phoenix_deps() ++
    [
      {:grenadier, in_umbrella: true},
    ]
  end

  def ecto do
    {:phoenix_ecto, "~> 4.0"}
  end

  def http_poison do
    {:httpoison, "~> 1.5"}
  end

  def floki do
    {:floki, "~> 0.21"}
  end

  def earmark do
    {:earmark, "~> 1.3.5"}
  end

  def argon2 do
    {:argon2_elixir, "~> 2.0"}
  end
end
