defmodule Grenadier.Repo.Migrations.ArtourRemoveTags do
  use Ecto.Migration

  def change do
    drop table(:post_tags, prefix: Grenadier.RepoPrefix.artour())
    drop table(:tags, prefix: Grenadier.RepoPrefix.artour())
  end
end
