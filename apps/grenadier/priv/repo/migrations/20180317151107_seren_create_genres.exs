defmodule Grenadier.Repo.Migration.SerenCreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres, prefix: Grenadier.RepoPrefix.seren()) do
      add :name, :text, null: false

      timestamps()
    end
    create unique_index(:genres, [:name], prefix: Grenadier.RepoPrefix.seren())
  end
end
