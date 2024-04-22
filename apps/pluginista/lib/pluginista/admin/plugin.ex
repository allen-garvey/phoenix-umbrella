defmodule Pluginista.Admin.Plugin do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.pluginista()
  schema "plugins" do
    field :acquisition_date, :date
    field :cost, :decimal, default: 0
    field :name, :string

    belongs_to :group, Pluginista.Admin.Group
    belongs_to :maker, Pluginista.Admin.Maker

    has_many :plugin_categories, Pluginista.Admin.PluginCategory
    many_to_many :categories, Pluginista.Admin.Category, join_through: Pluginista.Admin.PluginCategory

    timestamps()
  end

  @doc false
  def changeset(plugin, attrs) do
    plugin
    |> cast(attrs, [:name, :acquisition_date, :cost, :maker_id, :group_id])
    |> Common.ModelHelpers.Date.default_date_today(:acquisition_date)
    |> validate_required([:name, :cost, :maker_id, :group_id, :acquisition_date])
    |> assoc_constraint(:group)
    |> assoc_constraint(:maker)
  end
end
