defmodule Habits.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.habits()
  schema "categories" do
    field :name, :string
    field :color, :string

    has_many :activities, Habits.Admin.Activity

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :color])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end
