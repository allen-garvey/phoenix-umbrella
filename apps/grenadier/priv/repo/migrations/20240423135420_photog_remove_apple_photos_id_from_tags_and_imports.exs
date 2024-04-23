defmodule Grenadier.Repo.Migrations.PhotogRemoveApplePhotosIdFromTagsAndImports do
  use Ecto.Migration

  def change do
    alter table(:tags, prefix: Grenadier.RepoPrefix.photog()) do
      remove :apple_photos_uuid
    end
    alter table(:imports, prefix: Grenadier.RepoPrefix.photog()) do
      remove :apple_photos_uuid
    end
  end
end
