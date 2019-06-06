defmodule Teamster.Models.LegacyBook do
  use Ecto.Schema

  alias Booklist.Admin.Book


  schema "books" do
    field :title, :string
    field :subtitle, :string
    field :sort_title, :string
    field :author_id, :id
    field :genre_id, :id
    field :classification_id, :id
    field :date_added, :date
    field :pre_rating, :integer
    field :active, :boolean
    field :on_bookshelf, :boolean
    field :release_date, :date

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_book) do
  	%Book{
            id: legacy_book.id,
            inserted_at: legacy_book.created_at, 
            updated_at: legacy_book.updated_at,
            title: legacy_book.title, 
            subtitle: legacy_book.subtitle,
            sort_title: legacy_book.sort_title,
            author_id: legacy_book.author_id,
            genre_id: legacy_book.genre_id, 
            is_fiction: legacy_book.classification_id == 1,
            is_active: legacy_book.active,
            on_bookshelf: legacy_book.on_bookshelf
          }
  end
end