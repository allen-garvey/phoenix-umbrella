defmodule Grenadier.Repo.Migrations.BookmarkerCreatePrefix do
    use Ecto.Migration
  
    def change do
        prefix = Grenadier.RepoPrefix.bookmarker()
        execute "CREATE SCHEMA #{prefix}", "DROP SCHEMA #{prefix}"
    end
end
  