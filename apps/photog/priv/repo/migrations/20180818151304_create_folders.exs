defmodule Photog.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders) do
      add :apple_photos_uuid, :text, null: false
      add :name, :text, null: false

      timestamps()
    end
    create unique_index(:folders, [:apple_photos_uuid])
    create unique_index(:folders, [:name])
  end
end
