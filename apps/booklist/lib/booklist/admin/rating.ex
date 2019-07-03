defmodule Booklist.Admin.Rating do
  use Ecto.Schema
  import Ecto.Changeset


  schema "ratings" do
    field :date_scored, :date
    field :score, :integer

    belongs_to :book, Booklist.Admin.Book

    timestamps()
  end

  @doc """
  Validates rating score is between 1-100
  """
  def validate_score(changeset, attribute_key) do
    score = get_field(changeset, attribute_key)
    if !is_integer(score) or score < 1 or score > 100 do
      add_error(changeset, attribute_key, "Score must be between 1-100")
    else
      changeset
    end
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:date_scored, :score, :book_id])
    |> Common.ModelHelpers.Date.default_date_today(:date_scored)
    |> validate_required([:date_scored, :score, :book_id])
    |> assoc_constraint(:book)
    |> validate_score(:score)
  end
end
