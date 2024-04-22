defmodule Grenadier.Repo.Migrations.BlockquoteCreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :name, :string, null: false

      timestamps()
    end
    create unique_index(:categories, [:name], prefix: Grenadier.RepoPrefix.blockquote())
  end
end
