defmodule Bookmarker.Repo.Migrations.AddTagsUniqueIndex do
  use Ecto.Migration

  def change do
  	create unique_index(:tags, [:name])
  end
end
