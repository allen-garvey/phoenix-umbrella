defmodule Grenadier.Repo.Migrations.PluginistaCreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, prefix: Grenadier.RepoPrefix.pluginista()) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:groups, [:name], prefix: Grenadier.RepoPrefix.pluginista())
  end
end
