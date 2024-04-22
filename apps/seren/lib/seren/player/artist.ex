defmodule Seren.Player.Artist do
  use Ecto.Schema
  import Ecto.Changeset
  alias Seren.Player.Artist

  @schema_prefix Grenadier.RepoPrefix.seren()
  schema "artists" do
    field :name, :string

    timestamps()

    has_many :tracks, Seren.Player.Track
    has_many :albums, Seren.Player.Album
  end

  @doc false
  def changeset(%Artist{} = artist, attrs) do
    artist
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
