defmodule Artour.Repo.Migrations.AddUniqueNameAndSlugToCategories do
  use Ecto.Migration

  def change do
  	create unique_index(:categories, [:name])
  	create unique_index(:categories, [:slug])
  end
end
