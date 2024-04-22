defmodule Pluginista.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.pluginista()
  schema "categories" do
    field :name, :string

    belongs_to :group, Pluginista.Admin.Group

    has_many :plugin_categories, Pluginista.Admin.PluginCategory
    many_to_many :plugins, Pluginista.Admin.Plugin, join_through: Pluginista.Admin.PluginCategory

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :group_id])
    |> validate_required([:name, :group_id])
    |> assoc_constraint(:group)
    |> unique_constraint([:name, :group_id])
  end
end
