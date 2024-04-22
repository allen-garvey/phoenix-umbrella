defmodule Grenadier.Repo.Migrations.BookmarkerCreateTag do
  use Ecto.Migration

  def change do
    create table(:tags, prefix: Grenadier.RepoPrefix.bookmarker()) do
      add :name, :string

      timestamps()
    end

    create unique_index(:tags, [:name], prefix: Grenadier.RepoPrefix.bookmarker())

  end
end
