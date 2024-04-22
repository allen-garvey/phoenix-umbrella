defmodule Seren.Player.Album do
  use Ecto.Schema
  import Ecto.Changeset
  alias Seren.Player.Album

  @schema_prefix Grenadier.RepoPrefix.seren()
  schema "albums" do
    field :title, :string

    timestamps()

    belongs_to :artist, Seren.Player.Artist
    has_many :tracks, Seren.Player.Track
  end

  @doc false
  def changeset(%Album{} = album, attrs) do
    album
    |> cast(attrs, [:title, :artist_id])
    |> validate_required([:title, :artist_id])
    |> assoc_constraint(:artist)
  end
end
