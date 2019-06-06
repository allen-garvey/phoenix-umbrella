defmodule Photog.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :apple_photos_id, :integer, null: false
      add :name, :text, null: false
      add :folder_order, :integer, null: false
      add :folder_id, references(:folders, on_delete: :nothing), null: false
      add :cover_image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:albums, [:folder_id])
    create index(:albums, [:cover_image_id])

    create unique_index(:albums, [:apple_photos_id])
  end
end
