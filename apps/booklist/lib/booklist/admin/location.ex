defmodule Booklist.Admin.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.booklist()
  schema "locations" do
    field :name, :string

    belongs_to :library, Booklist.Admin.Library

    has_many :book_locations, Booklist.Admin.BookLocation
    many_to_many :books, Booklist.Admin.Book, join_through: Booklist.Admin.BookLocation

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :library_id])
    |> validate_required([:name, :library_id])
    |> assoc_constraint(:library)
  end
end
