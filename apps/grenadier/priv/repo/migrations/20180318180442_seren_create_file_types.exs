defmodule Grenadier.Repo.Migration.SerenCreateFileTypes do
  use Ecto.Migration

  def change do
    create table(:file_types, prefix: Grenadier.RepoPrefix.seren()) do
      add :name, :text

      timestamps()
    end
    create unique_index(:file_types, [:name], prefix: Grenadier.RepoPrefix.seren())
  end
end
