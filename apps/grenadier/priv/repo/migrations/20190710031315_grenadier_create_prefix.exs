defmodule Grenadier.Repo.Migrations.CreatePrefix do
    use Ecto.Migration
  
    def change do
        execute "CREATE SCHEMA #{Grenadier.RepoPrefix.grenadier()}", "DROP SCHEMA #{Grenadier.RepoPrefix.grenadier()}"
    end
  end
  