defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    ecto() ++
    phoenix_html() ++
    jason() ++
    [
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
      {:phoenix, "~> 1.7.18"},
      {:phoenix_html, "~> 4.2"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_view, "~> 2.0"},
    ]
  end

  def ecto do
    [
      {:phoenix_ecto, "~> 4.6.3"},
      {:ecto_sql, "~> 3.12"},
      {:postgrex, "~> 0.19.3"},
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
    {:floki, "~> 0.37"}
  end

  def argon2 do
    {:argon2_elixir, "~> 4.1.3"}
  end

  def phoenix_component do
    [
      {:phoenix_live_view, "~> 1.0.1"},
    ]
  end
end
