defmodule Booklist.Admin.Author do
  use Ecto.Schema
  import Ecto.Changeset


  schema "authors" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string

    has_many :books, Booklist.Admin.Book

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:first_name, :middle_name, :last_name])
    |> validate_required([:first_name])
  end
end
