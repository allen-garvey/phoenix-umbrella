defmodule Photog.Api.AlbumImage do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "album_images" do
    field :image_order, :integer

    belongs_to :image, Photog.Api.Image
    belongs_to :album, Photog.Api.Album

    timestamps()
  end

  @doc false
  def changeset(album_image, attrs) do
    album_image
    |> cast(attrs, [:image_order, :album_id, :image_id])
    |> validate_required([:album_id, :image_id])
    |> assoc_constraint(:image)
    |> assoc_constraint(:album)
    |> unique_constraint(:album_images_unique_composite, name: :album_images_unique_composite)
  end
end
