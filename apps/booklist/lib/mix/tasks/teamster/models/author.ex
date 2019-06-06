defmodule Teamster.Models.LegacyAuthor do
  use Ecto.Schema

  alias Booklist.Admin.Author


  schema "authors" do
    field :first, :string
    field :middle, :string
    field :last, :string

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_author) do
  	%Author{
            id: legacy_author.id,
            inserted_at: legacy_author.created_at, 
            updated_at: legacy_author.updated_at,
            first_name: legacy_author.first, 
            middle_name: legacy_author.middle, 
            last_name: legacy_author.last, 
          }
  end
end