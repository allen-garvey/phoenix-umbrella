defmodule Grenadier.Repo.Migrations.PhotogChangeAlbumTagsCascade do
  use Ecto.Migration

  def change do
    alter table(:album_tags, prefix: Grenadier.RepoPrefix.photog()) do
      modify :album_id, references(:albums, on_delete: :delete_all), from: references(:albums, on_delete: :nothing)
    end
  end
end
