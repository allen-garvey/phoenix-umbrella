defmodule Photog.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :apple_photos_id, :integer, null: false
      add :creation_time, :utc_datetime, null: false
      add :master_path, :text, null: false
      add :thumbnail_path, :text, null: false
      add :mini_thumbnail_path, :text, null: false
      add :is_favorite, :boolean, default: false, null: false

      timestamps()
    end
    create unique_index(:images, [:apple_photos_id])
    create unique_index(:images, [:master_path])

  end
end
