defmodule Grenadier.Repo.Migrations.HabitsCreatePrefix do
    use Ecto.Migration
  
    def change do
        execute "CREATE SCHEMA #{Grenadier.RepoPrefix.habits()}", "DROP SCHEMA #{Grenadier.RepoPrefix.habits()}"
    end
  end
  