defmodule Habits.Admin.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.habits()
  schema "activities" do
    field :date, :date
    field :description, :string

    belongs_to :tag, Habits.Admin.Tag

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:description, :date, :tag_id])
    |> Common.ModelHelpers.Date.default_date_today(:date)
    |> validate_required([:date, :tag_id])
    |> assoc_constraint(:tag)
  end
end
