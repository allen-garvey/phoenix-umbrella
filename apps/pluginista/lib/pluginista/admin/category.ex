defmodule Pluginista.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    belongs_to :group, Pluginista.Admin.Group

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
