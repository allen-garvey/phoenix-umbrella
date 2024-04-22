defmodule Grenadier.Repo.Migrations.BooklistCreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries, prefix: Grenadier.RepoPrefix.booklist()) do
      add :name, :text, null: false
      add :url, :text
      add :super_search_key, :text

      timestamps()
    end

    create unique_index(:libraries, [:name], prefix: Grenadier.RepoPrefix.booklist())

  end
end
