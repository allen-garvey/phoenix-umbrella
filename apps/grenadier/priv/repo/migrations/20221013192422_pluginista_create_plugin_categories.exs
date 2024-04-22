defmodule Grenadier.Repo.Migrations.PluginistaCreatePluginCategories do
  use Ecto.Migration

  def change do
    create table(:plugin_categories, prefix: Grenadier.RepoPrefix.pluginista()) do
      add :category_id, references(:categories, on_delete: :nothing), null: false
      add :plugin_id, references(:plugins, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:plugin_categories, [:category_id, :plugin_id], prefix: Grenadier.RepoPrefix.pluginista())
  end
end
