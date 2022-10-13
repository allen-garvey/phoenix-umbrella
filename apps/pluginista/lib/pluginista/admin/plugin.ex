defmodule Pluginista.Admin.Plugin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plugins" do
    field :acquisition_date, :date
    field :cost, :decimal
    field :name, :string

    belongs_to :group, Pluginista.Admin.Group
    belongs_to :maker, Pluginista.Admin.Maker

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
