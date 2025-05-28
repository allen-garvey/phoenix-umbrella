defmodule Photog.Api.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "images" do
    field(:creation_time, :utc_datetime)
    field(:is_favorite, :boolean, default: false)
    field(:master_path, :string)
    field(:mini_thumbnail_path, :string)
    field(:thumbnail_path, :string)
    field(:exif, :map, load_in_query: false)
    field(:amazon_photos_id, :string)
    field(:notes, :string)

    field(:has_albums, :boolean, default: false, virtual: true)
    field(:has_persons, :boolean, default: false, virtual: true)

    timestamps()

    belongs_to(:import, Photog.Api.Import)
    belongs_to(:source_image, Photog.Api.Image, foreign_key: :source_image_id)

    has_many(:album_images, Photog.Api.AlbumImage)
    has_many(:person_images, Photog.Api.PersonImage)
    has_many(:versions, Photog.Api.Image, foreign_key: :source_image_id)

    many_to_many(:albums, Photog.Api.Album, join_through: Photog.Api.AlbumImage)
    many_to_many(:persons, Photog.Api.Person, join_through: Photog.Api.PersonImage)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [
      :creation_time,
      :master_path,
      :thumbnail_path,
      :mini_thumbnail_path,
      :is_favorite,
      :import_id,
      :exif,
      :amazon_photos_id,
      :source_image_id,
      :notes
    ])
    |> validate_required([
      :creation_time,
      :master_path,
      :thumbnail_path,
      :mini_thumbnail_path,
      :is_favorite,
      :import_id
    ])
    |> assoc_constraint(:import)
    |> assoc_constraint(:source_image)
    |> unique_constraint(:master_path)
    |> unique_constraint(:amazon_photos_id)
  end
end
