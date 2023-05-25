defmodule Photog.Api.Year do
    use Ecto.Schema
    import Ecto.Changeset
  
    @primary_key {:id, :integer, []}
    schema "years" do
      field :description, :string
      
      belongs_to :cover_image, Photog.Api.Image
    end
  
    @doc false
    def changeset(year, attrs) do
      year
      |> cast(attrs, [:id, :description, :cover_image_id])
      |> validate_required([:id])
      |> assoc_constraint(:cover_image)
    end
  end
  