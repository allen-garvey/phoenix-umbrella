defmodule Grenadier.Repo.Migrations.PhotogCreateAlbumTags do
  use Ecto.Migration

  def change do
    create table(:album_tags, prefix: Grenadier.RepoPrefix.photog()) do
      add :album_order, :integer
      add :album_id, references(:albums, on_delete: :nothing), null: false
      add :tag_id, references(:tags, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:album_tags, [:album_id], prefix: Grenadier.RepoPrefix.photog())
    create index(:album_tags, [:tag_id], prefix: Grenadier.RepoPrefix.photog())

    create unique_index(:album_tags, [:album_id, :tag_id], name: "album_tags_unique_composite", prefix: Grenadier.RepoPrefix.photog())
  end
end
