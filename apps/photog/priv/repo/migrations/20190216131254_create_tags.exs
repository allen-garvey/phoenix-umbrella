defmodule Photog.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :text, null: false
      add :apple_photos_uuid, :text

      timestamps()
    end

    create unique_index(:tags, [:apple_photos_uuid])
    create unique_index(:tags, [:name])
  end
end
