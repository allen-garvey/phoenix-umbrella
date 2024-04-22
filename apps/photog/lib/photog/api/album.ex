defmodule Photog.Api.Album do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "albums" do
    field :name, :string
    field :description, :string
    field :year, :integer
    field :is_favorite, :boolean, default: false
    field :images_count, :integer, default: -1, virtual: true

    timestamps()

    belongs_to :cover_image, Photog.Api.Image

    has_many :album_images, Photog.Api.AlbumImage
    many_to_many :images, Photog.Api.Image, join_through: Photog.Api.AlbumImage

    has_many :album_tags, Photog.Api.AlbumTag
    many_to_many :tags, Photog.Api.Tag, join_through: Photog.Api.AlbumTag

    has_many :years, Photog.Api.Year
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :cover_image_id, :description, :year, :is_favorite])
    |> Common.ModelHelpers.Date.default_year_today(:year)
    |> validate_required([:name, :cover_image_id, :year, :is_favorite])
    |> assoc_constraint(:cover_image)
  end
end
