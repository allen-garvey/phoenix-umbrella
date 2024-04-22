defmodule Booklist.Admin.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.booklist()
  schema "books" do
    field :is_fiction, :boolean, default: false
    field :is_active, :boolean, default: true
    field :on_bookshelf, :boolean, default: false
    field :sort_title, :string
    field :subtitle, :string
    field :title, :string

    belongs_to :author, Booklist.Admin.Author
    belongs_to :genre, Booklist.Admin.Genre

    has_many :ratings, Booklist.Admin.Rating

    has_many :book_locations, Booklist.Admin.BookLocation
    many_to_many :locations, Booklist.Admin.Location, join_through: Booklist.Admin.BookLocation

    timestamps()
  end

  @doc """
  Adds sort_title to changeset generated from title
  """
  def generate_sort_title(changeset) do
    change(changeset, %{sort_title: sort_title_from(get_field(changeset, :title))})
  end

  def sort_title_from(nil) do
    nil
  end

  def sort_title_from(title) do
    Regex.replace(~r/^the\s+/i, title, "")
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :sort_title, :subtitle, :is_fiction, :genre_id, :author_id, :is_active, :on_bookshelf])
    # sort_title is required, but we are not validating it here since it generated from the title
    #is_active and on_bookshelf is required, but not validating since using defaults if they are not set
    |> validate_required([:title, :is_fiction, :genre_id])
    |> generate_sort_title
    |> assoc_constraint(:author)
    |> assoc_constraint(:genre)
  end
end
