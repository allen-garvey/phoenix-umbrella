defmodule Grenadier.Repo.Migrations.GrenadierCreatePrefix do
    use Ecto.Migration
  
    def change do
        execute "CREATE SCHEMA #{Grenadier.RepoPrefix.grenadier()}", "DROP SCHEMA #{Grenadier.RepoPrefix.grenadier()}"
    end
  end
  