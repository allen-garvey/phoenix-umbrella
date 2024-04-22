defmodule Booklist.Admin.BookLocation do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.booklist()
  schema "book_locations" do
    field :call_number, :string

    belongs_to :location, Booklist.Admin.Location
    belongs_to :book, Booklist.Admin.Book

    timestamps()
  end

  @doc false
  def changeset(book_location, attrs) do
    book_location
    |> cast(attrs, [:call_number, :book_id, :location_id])
    |> validate_required([:book_id, :location_id])
    |> assoc_constraint(:book)
    |> assoc_constraint(:location)
  end
end
