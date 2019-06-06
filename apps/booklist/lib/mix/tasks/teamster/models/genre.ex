defmodule Teamster.Models.LegacyGenre do
  use Ecto.Schema

  alias Booklist.Admin.Genre


  schema "genres" do
    field :name, :string

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Migrates legacy model to current booklist model
  """
  def migrate(legacy_genre) do
  	%Genre{id: legacy_genre.id, name: legacy_genre.name, inserted_at: legacy_genre.created_at, updated_at: legacy_genre.updated_at}
  end
end