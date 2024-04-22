defmodule Grenadier.Repo.Migrations.PhotogCreatePersonImages do
  use Ecto.Migration

  def change do
    create table(:person_images, prefix: Grenadier.RepoPrefix.photog()) do
      add :person_id, references(:persons, on_delete: :nothing), null: false
      add :image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:person_images, [:person_id], prefix: Grenadier.RepoPrefix.photog())
    create index(:person_images, [:image_id], prefix: Grenadier.RepoPrefix.photog())

    create unique_index(:person_images, [:person_id, :image_id], name: "person_images_unique_composite", prefix: Grenadier.RepoPrefix.photog())
  end
end
