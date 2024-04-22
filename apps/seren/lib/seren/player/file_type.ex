defmodule Seren.Player.FileType do
  use Ecto.Schema
  import Ecto.Changeset
  alias Seren.Player.FileType

  @schema_prefix Grenadier.RepoPrefix.seren()
  schema "file_types" do
    field :name, :string

    timestamps()

    has_many :tracks, Seren.Player.Track
  end

  @doc false
  def changeset(%FileType{} = file_type, attrs) do
    file_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
