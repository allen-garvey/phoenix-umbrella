defmodule Teamster.Models.LegacyBookLocation do
  use Ecto.Schema

  alias Booklist.Admin.BookLocation


  schema "book_locations" do
    field :book_id, :id
    field :location_id, :id
    field :call_number, :string

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_book_location) do
  	%BookLocation{
            id: legacy_book_location.id,
            inserted_at: legacy_book_location.created_at, 
            updated_at: legacy_book_location.updated_at,
            book_id: legacy_book_location.book_id, 
            location_id: legacy_book_location.location_id, 
            call_number: legacy_book_location.call_number, 
          }
  end
end