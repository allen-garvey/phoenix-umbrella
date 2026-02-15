defmodule Habits.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, prefix: Grenadier.RepoPrefix.habits()) do
      add :name, :text, null: false
      add :category_id, references(:categories, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:tags, [:category_id], prefix: Grenadier.RepoPrefix.habits())
    create unique_index(:tags, [:name, :category_id], prefix: Grenadier.RepoPrefix.habits())

    alter table(:activities, prefix: Grenadier.RepoPrefix.habits()) do
      add :tag_id, references(:tags, on_delete: :nothing)
    end
  end
end
