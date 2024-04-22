defmodule Grenadier.Repo.Migrations.PhotogCreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, prefix: Grenadier.RepoPrefix.photog()) do
      add :name, :text, null: false
      add :apple_photos_uuid, :text
      add :is_favorite, :boolean, default: false, null: false
      add :cover_album_id, references(:albums, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:tags, [:apple_photos_uuid], prefix: Grenadier.RepoPrefix.photog())
    create unique_index(:tags, [:name], prefix: Grenadier.RepoPrefix.photog())
  end
end
