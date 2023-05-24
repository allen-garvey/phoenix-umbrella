defmodule Photog.Api.Year do
    use Ecto.Schema
    import Ecto.Changeset
  
    @primary_key {:id, :integer, []}
    schema "years" do
      field :description, :string
    end
  
    @doc false
    def changeset(year, attrs) do
      year
      |> cast(attrs, [:id, :description])
      |> validate_required([:id, :description])
    end
  end
  