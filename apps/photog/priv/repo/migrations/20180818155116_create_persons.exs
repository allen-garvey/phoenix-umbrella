defmodule Photog.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :apple_photos_id, :integer, null: false
      add :name, :text, null: false
      add :cover_image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:persons, [:cover_image_id])

    create unique_index(:persons, [:apple_photos_id])
    create unique_index(:persons, [:name])
  end
end
