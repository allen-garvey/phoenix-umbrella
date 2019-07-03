defmodule Umbrella.Common.Deps do
  # Shared dependencies for phoenix projects
  def shared_phoenix_deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      ecto(),
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.14.0"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.16"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.0"},
      {:common, in_umbrella: true},
    ]
  end

  def ecto do
    {:phoenix_ecto, "~> 4.0"}
  end
end
