defmodule Grenadier.Repo.Migrations.ArtourCreatePrefix do
    use Ecto.Migration
  
    def change do
        prefix = Grenadier.RepoPrefix.artour()
        execute "CREATE SCHEMA #{prefix}", "DROP SCHEMA #{prefix}"
    end
end
  