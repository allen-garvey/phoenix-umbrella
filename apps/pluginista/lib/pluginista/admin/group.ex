defmodule Pluginista.Admin.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string

    has_many :categories, Pluginista.Admin.Category

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
