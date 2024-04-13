defmodule Photog.Api.YearImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "year_images" do
    field :year, :integer

    belongs_to :image, Photog.Api.Image
  end

  @doc false
  def changeset(year_image, attrs) do
    year_image
    |> cast(attrs, [:year, :image_id])
    |> validate_required([:year, :image_id])
    |> assoc_constraint(:image)
  end
end
