defmodule Grenadier.Repo.Migrations.PhotogCreatePrefix do
    use Ecto.Migration
  
    def change do
        prefix = Grenadier.RepoPrefix.photog()
        execute "CREATE SCHEMA #{prefix}", "DROP SCHEMA #{prefix}"
    end
end
  