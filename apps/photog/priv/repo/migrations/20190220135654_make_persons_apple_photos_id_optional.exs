defmodule Photog.Repo.Migrations.MakePersonsApplePhotosIdOptional do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      modify :apple_photos_id, :integer, null: true
    end
  end
end
