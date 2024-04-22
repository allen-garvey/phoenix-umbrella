defmodule Habits.Admin.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.habits()
  schema "activities" do
    field :date, :date
    field :description, :string
    field :title, :string

    belongs_to :category, Habits.Admin.Category

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :description, :date, :category_id])
    |> Common.ModelHelpers.Date.default_date_today(:date)
    |> validate_required([:title, :date, :category_id])
    |> assoc_constraint(:category)
  end
end
