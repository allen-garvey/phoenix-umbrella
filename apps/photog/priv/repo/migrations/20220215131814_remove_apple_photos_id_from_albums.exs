defmodule Photog.Repo.Migrations.RemoveApplePhotosIdFromAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      remove :apple_photos_id
    end
  end
end
