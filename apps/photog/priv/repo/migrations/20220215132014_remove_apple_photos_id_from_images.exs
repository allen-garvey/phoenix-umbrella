defmodule Photog.Repo.Migrations.RemoveApplePhotosIdFromImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      remove :apple_photos_id
    end
  end
end
