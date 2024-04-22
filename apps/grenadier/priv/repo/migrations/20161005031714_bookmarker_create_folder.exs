defmodule Grenadier.Repo.Migrations.BookmarkerCreateFolder do
  use Ecto.Migration

  def change do
    create table(:folders, prefix: Grenadier.RepoPrefix.bookmarker()) do
      add :name, :string
      add :description, :string
      add :is_favorite, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:folders, [:name], prefix: Grenadier.RepoPrefix.bookmarker())

  end
end
