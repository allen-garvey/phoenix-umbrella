defmodule Grenadier.Repo.Migrations.PluginistaCreateMakers do
  use Ecto.Migration

  def change do
    create table(:makers, prefix: Grenadier.RepoPrefix.pluginista()) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:makers, [:name], prefix: Grenadier.RepoPrefix.pluginista())
  end
end
