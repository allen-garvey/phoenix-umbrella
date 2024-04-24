defmodule Grenadier.Repo.Migrations.ArtourRemoveCategories do
  use Ecto.Migration

  def change do
    alter table(:posts, prefix: Grenadier.RepoPrefix.artour()) do
      remove :category_id
    end
    drop table(:categories, prefix: Grenadier.RepoPrefix.artour())
  end
end
