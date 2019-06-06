defmodule Photog.Repo.Migrations.CreatePersonImages do
  use Ecto.Migration

  def change do
    create table(:person_images) do
      add :person_id, references(:persons, on_delete: :nothing), null: false
      add :image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:person_images, [:person_id])
    create index(:person_images, [:image_id])

    create unique_index(:person_images, [:person_id, :image_id], name: "person_images_unique_composite")
  end
end
