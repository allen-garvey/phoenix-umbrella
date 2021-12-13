defmodule Photog.Api.Person do
  use Ecto.Schema
  import Ecto.Changeset


  schema "persons" do
    field :apple_photos_id, :integer, load_in_query: false
    field :name, :string
    field :images_count, :integer, default: -1, virtual: true

    timestamps()

    belongs_to :cover_image, Photog.Api.Image
    has_many :person_images, Photog.Api.PersonImage
    many_to_many :images, Photog.Api.Image, join_through: "person_images"
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:apple_photos_id, :name, :cover_image_id])
    |> validate_required([:name, :cover_image_id])
    |> unique_constraint(:apple_photos_id)
    |> unique_constraint(:name)
    |> assoc_constraint(:cover_image)
  end
end
