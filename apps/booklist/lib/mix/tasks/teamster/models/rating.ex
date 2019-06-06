defmodule Teamster.Models.LegacyRating do
  use Ecto.Schema

  alias Booklist.Admin.Rating


  schema "ratings" do
    field :book_id, :id
    field :post_rating, :integer
    field :date_added, :date

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_rating) do
  	%Rating{
            id: legacy_rating.id,
            inserted_at: legacy_rating.created_at, 
            updated_at: legacy_rating.updated_at,
            book_id: legacy_rating.book_id, 
            score: legacy_rating.post_rating, 
            date_scored: legacy_rating.date_added, 
          }
  end
end