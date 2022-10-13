defmodule Pluginista.Admin.Plugin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plugins" do
    field :acquisition_date, :date
    field :cost, :decimal
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
    |> validate_required([:name, :acquisition_date, :cost, :maker_id, :group_id])
    |> assoc_constraint(:group)
    |> assoc_constraint(:maker)
  end
end
