defmodule Booklist.Admin.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.booklist()
  schema "genres" do
    field :name, :string
    field :is_fiction, :boolean, default: false

    has_many :books,   Booklist.Admin.Book
    has_many :authors, Booklist.Admin.Author

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name, :is_fiction])
    |> validate_required([:name, :is_fiction])
    |> unique_constraint(:name)
  end
end
