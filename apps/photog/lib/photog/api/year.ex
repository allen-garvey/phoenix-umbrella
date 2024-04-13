defmodule Photog.Api.Year do
    use Ecto.Schema
    import Ecto.Changeset
  
    @primary_key {:id, :integer, []}
    schema "years" do
      field :description, :string
      
      belongs_to :album, Photog.Api.Album
    end
  
    @doc false
    def changeset(year, attrs) do
      year
      |> cast(attrs, [:id, :description, :album_id])
      |> validate_required([:id])
      |> assoc_constraint(:album)
    end
  end
  