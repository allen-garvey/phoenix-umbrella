defmodule Pluginista.Admin.PluginCategory do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.pluginista()
  schema "plugin_categories" do
    belongs_to :category, Pluginista.Admin.Category
    belongs_to :plugin, Pluginista.Admin.Plugin

    timestamps()
  end

  @doc false
  def changeset(plugin_category, attrs) do
    plugin_category
    |> cast(attrs, [:category_id, :plugin_id])
    |> validate_required([:category_id, :plugin_id])
    |> assoc_constraint(:category)
    |> assoc_constraint(:plugin)
    |> unique_constraint([:category_id, :plugin_id])
  end
end
