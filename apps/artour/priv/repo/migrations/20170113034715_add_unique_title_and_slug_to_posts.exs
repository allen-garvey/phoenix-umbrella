defmodule Artour.Repo.Migrations.AddUniqueTitleAndSlugToPosts do
  use Ecto.Migration

  def change do
  	create unique_index(:posts, [:title])
  	create unique_index(:posts, [:slug])
  end
end
