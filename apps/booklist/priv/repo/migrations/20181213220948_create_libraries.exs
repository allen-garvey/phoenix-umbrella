defmodule Booklist.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :name, :text, null: false
      add :url, :text
      add :super_search_key, :text

      timestamps()
    end

    create unique_index(:libraries, [:name])

  end
end
