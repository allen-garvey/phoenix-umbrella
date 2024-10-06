defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    ecto() ++
    phoenix_html() ++
    jason() ++
    [
      {:phoenix_pubsub, "~> 2.1"},
      {:phoenix_live_reload, "~> 1.5", only: :dev},
      {:plug_cowboy, "~> 2.7.2"},
      {:common, in_umbrella: true},
      {:assertions, "~> 0.20", only: :test},
    ]
  end

  def shared_authenticated_phoenix_deps do
    shared_phoenix_deps() ++
    [
      {:grenadier, in_umbrella: true},
    ]
  end

  def phoenix_html do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_html, "~> 4.1"},
      {:gettext, "~> 0.26"},
    ]
  end

  def ecto do
    [
      {:phoenix_ecto, "~> 4.6"},
      {:ecto_sql, "~> 3.12"},
      {:postgrex, "~> 0.19"},
    ]
  end

  def jason do
    [
      {:jason, "~> 1.4"},
    ]
  end

  def http_poison do
    {:httpoison, "~> 2.2"}
  end

  def floki do
    {:floki, "~> 0.36"}
  end

  def earmark do
    {:earmark, "~> 1.4.47"}
  end

  def argon2 do
    {:argon2_elixir, "~> 4.1"}
  end

  def telemetry do
    [
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.1"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:phoenix_live_view, "~> 0.20"},
    ]
  end
end
