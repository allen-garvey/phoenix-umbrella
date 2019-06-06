defmodule Photog.Repo.Migrations.CreateAlbumImages do
  use Ecto.Migration

  def change do
    create table(:album_images) do
      add :image_order, :integer, null: false
      add :album_id, references(:albums, on_delete: :nothing), null: false
      add :image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:album_images, [:album_id])
    create index(:album_images, [:image_id])

    create unique_index(:album_images, [:album_id, :image_id], name: "album_images_unique_composite")
  end
end
