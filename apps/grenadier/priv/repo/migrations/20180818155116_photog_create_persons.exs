defmodule Grenadier.Repo.Migrations.PhotogCreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons, prefix: Grenadier.RepoPrefix.photog()) do
      add :name, :text, null: false
      add :cover_image_id, references(:images, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:persons, [:cover_image_id], prefix: Grenadier.RepoPrefix.photog())
    create unique_index(:persons, [:name], prefix: Grenadier.RepoPrefix.photog())
  end
end
