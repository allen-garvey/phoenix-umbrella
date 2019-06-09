defmodule Movielist.Admin.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  alias Movielist.Admin.ModelHelpers


  schema "ratings" do
    field :date_scored, :date
    field :score, :integer
    
    belongs_to :movie, Movielist.Admin.Movie

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:movie_id, :date_scored, :score])
    |> ModelHelpers.default_date_today(:date_scored)
    |> validate_required([:movie_id, :date_scored, :score])
    |> ModelHelpers.validate_score(:score)
    |> assoc_constraint(:movie)
  end
end
