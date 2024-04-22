defmodule Grenadier.Repo.Migration.SerenCreateComposers do
  use Ecto.Migration

  def change do
    create table(:composers, prefix: Grenadier.RepoPrefix.seren()) do
      add :name, :text

      timestamps()
    end
    create unique_index(:composers, [:name], prefix: Grenadier.RepoPrefix.seren())
  end
end
