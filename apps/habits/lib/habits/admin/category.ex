defmodule Habits.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.habits()
  schema "categories" do
    field :name, :string
    field :color, :string
    field :is_favorite, :boolean, default: false

    field :has_daily_activity, :boolean, virtual: true

    has_many :activities, Habits.Admin.Activity

    timestamps()
  end

  defp validate_color(changeset, color_key) do
    case(Enum.member?(HabitsWeb.CategoryView.colors(), get_field(changeset, color_key))) do
      true -> changeset
      false -> add_error(changeset, color_key, "Invalid color.")
    end
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :color, :is_favorite])
    |> validate_required([:name, :color])
    |> validate_color(:color)
    |> unique_constraint([:name])
  end
end
