defmodule Photog.Api.Import do
  use Ecto.Schema
  import Ecto.Changeset


  schema "imports" do
    field :apple_photos_uuid, :string
    field :import_time, :utc_datetime

    timestamps()

    has_many :images, Photog.Api.Image
  end

  @doc false
  def changeset(import, attrs) do
    import
    |> cast(attrs, [:import_time, :apple_photos_uuid])
    |> Photog.ModelHelpers.Date.default_datetime_now(:import_time)
    |> validate_required([:import_time])
    |> unique_constraint(:apple_photos_uuid)
  end
end
