defmodule Photog.Api.Person do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "persons" do
    field :name, :string
    field :is_favorite, :boolean, default: false
    field :images_count, :integer, default: -1, virtual: true

    timestamps()

    belongs_to :cover_image, Photog.Api.Image
    has_many :person_images, Photog.Api.PersonImage
    many_to_many :images, Photog.Api.Image, join_through: Photog.Api.PersonImage
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :cover_image_id, :is_favorite])
    |> validate_required([:name, :cover_image_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:cover_image)
  end
end
