defmodule Teamster.Models.LegacyLocation do
  use Ecto.Schema

  alias Booklist.Admin.Location


  schema "locations" do
    field :name, :string
    field :library_id, :id

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_location) do
  	%Location{
            id: legacy_location.id,
            inserted_at: legacy_location.created_at, 
            updated_at: legacy_location.updated_at,
            name: legacy_location.name, 
            library_id: legacy_location.library_id, 
          }
  end
end