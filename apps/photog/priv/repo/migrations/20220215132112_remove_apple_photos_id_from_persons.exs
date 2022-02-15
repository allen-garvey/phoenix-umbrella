defmodule Photog.Repo.Migrations.RemoveApplePhotosIdFromPersons do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      remove :apple_photos_id
    end
  end
end
