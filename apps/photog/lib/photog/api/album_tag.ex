defmodule Photog.Api.AlbumTag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "album_tags" do
    field :album_order, :integer, default: -1

    timestamps()

    belongs_to :album, Photog.Api.Album
    belongs_to :tag, Photog.Api.Tag
  end

  @doc false
  def changeset(album_tag, attrs) do
    album_tag
    |> cast(attrs, [:album_order, :album_id, :tag_id])
    |> validate_required([:album_id, :tag_id])
    |> assoc_constraint(:album)
    |> assoc_constraint(:tag)
    |> unique_constraint(:album_tags_unique_composite, name: :album_tags_unique_composite)
  end
end
