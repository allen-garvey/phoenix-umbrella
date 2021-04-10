defmodule Photog.Api.Album do
  use Ecto.Schema
  import Ecto.Changeset


  schema "albums" do
    field :apple_photos_id, :integer
    field :name, :string
    field :description, :string
    field :images_count, :integer, default: -1, virtual: true

    timestamps()

    belongs_to :cover_image, Photog.Api.Image

    has_many :album_images, Photog.Api.AlbumImage
    many_to_many :images, Photog.Api.Image, join_through: "album_images"

    has_many :album_tags, Photog.Api.AlbumTag
    many_to_many :tags, Photog.Api.Tag, join_through: "album_tags"
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:apple_photos_id, :name, :cover_image_id, :description])
    |> validate_required([:name, :cover_image_id])
    |> unique_constraint(:apple_photos_id)
    |> assoc_constraint(:cover_image)
  end
end
