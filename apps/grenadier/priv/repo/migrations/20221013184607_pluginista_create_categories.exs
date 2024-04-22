defmodule Grenadier.Repo.Migrations.PluginistaCreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, prefix: Grenadier.RepoPrefix.pluginista()) do
      add :name, :text, null: false
      add :group_id, references(:groups, on_delete: :nothing), null: false

      timestamps()
    end
    
    create unique_index(:categories, [:name, :group_id], prefix: Grenadier.RepoPrefix.pluginista())
  end
end
