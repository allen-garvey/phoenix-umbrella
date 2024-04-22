defmodule Grenadier.Repo.Migrations.PhotogCreateImports do
  use Ecto.Migration

  def change do
    create table(:imports, prefix: Grenadier.RepoPrefix.photog()) do
      add :import_time, :utc_datetime, null: false
      add :notes, :text
      add :apple_photos_uuid, :text

      timestamps()
    end
  end
end
