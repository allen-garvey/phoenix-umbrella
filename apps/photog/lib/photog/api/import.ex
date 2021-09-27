defmodule Photog.Api.Import do
  use Ecto.Schema
  import Ecto.Changeset


  schema "imports" do
    field :apple_photos_uuid, :string
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
    |> cast(attrs, [:import_time, :apple_photos_uuid, :notes, :cover_image_id])
    |> Common.ModelHelpers.Date.default_datetime_now(:import_time)
    |> validate_required([:import_time])
    |> unique_constraint(:apple_photos_uuid)
    |> assoc_constraint(:cover_image)
  end
end
