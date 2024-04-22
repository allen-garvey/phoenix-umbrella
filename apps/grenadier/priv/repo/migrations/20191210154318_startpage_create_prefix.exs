defmodule Grenadier.Repo.Migrations.StartpageCreatePrefix do
    use Ecto.Migration
  
    def change do
        prefix = Grenadier.RepoPrefix.startpage()
        execute "CREATE SCHEMA #{prefix}", "DROP SCHEMA #{prefix}"
    end
end
  