defmodule Photog.Repo.Migrations.CreateAlbumTags do
  use Ecto.Migration

  def change do
    create table(:album_tags) do
      add :album_order, :integer
      add :album_id, references(:albums, on_delete: :nothing), null: false
      add :tag_id, references(:tags, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:album_tags, [:album_id])
    create index(:album_tags, [:tag_id])

    create unique_index(:album_tags, [:album_id, :tag_id], name: "album_tags_unique_composite")
  end
end
