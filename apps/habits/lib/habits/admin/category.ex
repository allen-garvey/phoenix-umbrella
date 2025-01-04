defmodule Habits.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.habits()
  schema "categories" do
    field :name, :string
    field :color, :string
    field :is_favorite, :boolean, default: false

    has_many :activities, Habits.Admin.Activity

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :color, :is_favorite])
    |> validate_required([:name, :color])
    |> unique_constraint([:name])
  end
end
