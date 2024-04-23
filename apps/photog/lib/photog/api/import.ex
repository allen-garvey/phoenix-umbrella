defmodule Photog.Api.Import do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "imports" do
    field :import_time, :utc_datetime
    field :notes, :string
    field :images_count, :integer, default: -1, virtual: true
    field :camera_model, :string, virtual: true

    timestamps()

    belongs_to :cover_image, Photog.Api.Image
    has_many :images, Photog.Api.Image
  end

  @doc false
  def changeset(import, attrs) do
    import
    |> cast(attrs, [:import_time, :notes, :cover_image_id])
    |> Common.ModelHelpers.Date.default_datetime_now(:import_time)
    |> validate_required([:import_time])
    |> assoc_constraint(:cover_image)
  end

  def determine_camera_model(nil, nil) do
    nil
  end

  def determine_camera_model(camera_make, nil) do
    camera_make
  end

  def determine_camera_model(nil, camera_model) do
    camera_model
  end

  def determine_camera_model(camera_make, camera_model) do
    "#{camera_make} #{camera_model}"
  end
end
