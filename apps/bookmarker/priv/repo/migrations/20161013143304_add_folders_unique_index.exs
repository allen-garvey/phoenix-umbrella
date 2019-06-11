defmodule Bookmarker.Repo.Migrations.AddFoldersUniqueIndex do
  use Ecto.Migration

  def change do
  	create unique_index(:folders, [:name])
  end
end
