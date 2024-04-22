defmodule Grenadier.Repo.Migrations.PhotogCreateAlbumImages do
  use Ecto.Migration

  def change do
    create table(:album_images, prefix: Grenadier.RepoPrefix.photog()) do
      add :image_order, :integer
      add :album_id, references(:albums, on_delete: :nothing), null: false
      add :image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:album_images, [:album_id], prefix: Grenadier.RepoPrefix.photog())
    create index(:album_images, [:image_id], prefix: Grenadier.RepoPrefix.photog())

    create unique_index(:album_images, [:album_id, :image_id], name: "album_images_unique_composite", prefix: Grenadier.RepoPrefix.photog())
  end
end
