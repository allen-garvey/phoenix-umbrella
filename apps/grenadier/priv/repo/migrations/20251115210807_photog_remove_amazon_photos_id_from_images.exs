defmodule Grenadier.Repo.Migrations.PhotogRemoveAmazonPhotosIdFromImages do
  use Ecto.Migration

  def change do
    alter table(:images, prefix: Grenadier.RepoPrefix.photog()) do
      remove :amazon_photos_id
    end
  end
end
