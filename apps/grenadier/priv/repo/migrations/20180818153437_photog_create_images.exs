defmodule Grenadier.Repo.Migrations.PhotogCreateImages do
  use Ecto.Migration

  def change do
    create table(:images, prefix: Grenadier.RepoPrefix.photog()) do
      add :creation_time, :utc_datetime, null: false
      add :master_path, :text, null: false
      add :thumbnail_path, :text, null: false
      add :mini_thumbnail_path, :text, null: false
      add :is_favorite, :boolean, default: false, null: false
      add :notes, :text
      add :amazon_photos_id, :text
      add :exif, :map
      add :completion_date, :date
      add :import_id, references(:imports, on_delete: :nothing), null: false

      timestamps()
    end
    create unique_index(:images, [:master_path], prefix: Grenadier.RepoPrefix.photog())
    create unique_index(:images, [:amazon_photos_id], prefix: Grenadier.RepoPrefix.photog())

  end
end
