defmodule Photog.Api.PersonImage do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "person_images" do
    belongs_to :image, Photog.Api.Image
    belongs_to :person, Photog.Api.Person

    timestamps()
  end

  @doc false
  def changeset(person_image, attrs) do
    person_image
    |> cast(attrs, [:person_id, :image_id])
    |> validate_required([:person_id, :image_id])
    |> assoc_constraint(:image)
    |> assoc_constraint(:person)
    |> unique_constraint(:person_images_unique_composite, name: :person_images_unique_composite)
  end
end
