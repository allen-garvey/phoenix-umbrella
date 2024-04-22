defmodule Booklist.Admin.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.booklist()
  schema "ratings" do
    field :date_scored, :date
    field :score, :integer

    belongs_to :book, Booklist.Admin.Book

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:date_scored, :score, :book_id])
    |> Common.ModelHelpers.Date.default_date_today(:date_scored)
    |> validate_required([:date_scored, :score, :book_id])
    |> assoc_constraint(:book)
    |> Common.ModelHelpers.Number.validate_score(:score)
  end
end
