defmodule Grenadier.Repo.Migrations.SupersearchCreateEngines do
  use Ecto.Migration

  def change do
    prefix = Grenadier.RepoPrefix.supersearch()
    execute "CREATE SCHEMA #{prefix}", "DROP SCHEMA #{prefix}"

    create table(:engines, prefix: prefix) do
      add :name, :text
      add :url, :text
      add :order, :integer

      timestamps()
    end
  end
end
