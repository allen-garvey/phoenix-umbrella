defmodule Photog.Api.Image do
  use Ecto.Schema
  import Ecto.Changeset


  schema "images" do
    field :apple_photos_id, :integer
    field :creation_time, :utc_datetime
    field :is_favorite, :boolean, default: false
    field :master_path, :string
    field :mini_thumbnail_path, :string
    field :thumbnail_path, :string

    timestamps()

    belongs_to :import, Photog.Api.Import

    has_many :album_images, Photog.Api.AlbumImage
    has_many :person_images, Photog.Api.PersonImage

    many_to_many :albums, Photog.Api.Album, join_through: "album_images"
    many_to_many :persons, Photog.Api.Person, join_through: "person_images"
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:apple_photos_id, :creation_time, :master_path, :thumbnail_path, :mini_thumbnail_path, :is_favorite, :import_id])
    |> validate_required([:creation_time, :master_path, :thumbnail_path, :mini_thumbnail_path, :is_favorite, :import_id])
    |> assoc_constraint(:import)
    |> unique_constraint(:master_path)
    |> unique_constraint(:apple_photos_id)
  end
end
