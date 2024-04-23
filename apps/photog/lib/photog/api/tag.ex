defmodule Photog.Api.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "tags" do
    field :name, :string
    field :is_favorite, :boolean, default: false
    field :cover_image, :string, default: nil, virtual: true
    field :albums_count, :integer, default: -1, virtual: true

    timestamps()

    belongs_to :cover_album, Photog.Api.Album

    has_many :album_tags, Photog.Api.AlbumTag
    many_to_many :albums, Photog.Api.Album, join_through: Photog.Api.AlbumTag
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :cover_album_id, :is_favorite])
    |> validate_required([:name, :is_favorite])
    |> unique_constraint(:name)
    |> assoc_constraint(:cover_album)
  end
end
