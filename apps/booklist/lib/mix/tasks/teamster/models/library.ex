defmodule Teamster.Models.LegacyLibrary do
  use Ecto.Schema

  alias Booklist.Admin.Library


  schema "libraries" do
    field :name, :string
    field :url, :string
    field :super_search_url, :string

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_library) do
  	%Library{
            id: legacy_library.id,
            inserted_at: legacy_library.created_at, 
            updated_at: legacy_library.updated_at,
            name: legacy_library.name, 
            super_search_key: legacy_library.super_search_url, 
            url: legacy_library.url, 
          }
  end
end