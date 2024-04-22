defmodule Grenadier.Repo.Migrations.BooklistCreatePrefix do
    use Ecto.Migration
  
    def change do
        prefix = Grenadier.RepoPrefix.booklist()
        execute "CREATE SCHEMA #{prefix}", "DROP SCHEMA #{prefix}"
    end
end
  