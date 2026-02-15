defmodule Habits.Admin.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.habits()
  schema "tags" do
    field :name, :string

    belongs_to :category, Habits.Admin.Category
    has_many :activities, Habits.Admin.Activity

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :category_id])
    |> validate_required([:name, :category_id])
    |> assoc_constraint(:category)
    |> unique_constraint([:name, :category_id])
  end
end
