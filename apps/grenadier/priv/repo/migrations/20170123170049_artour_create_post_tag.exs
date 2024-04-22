defmodule Grenadier.Repo.Migrations.ArtourCreatePostTag do
  use Ecto.Migration

  def change do
    create table(:post_tags, prefix: Grenadier.RepoPrefix.artour()) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)

      timestamps()
    end
    create index(:post_tags, [:post_id], prefix: Grenadier.RepoPrefix.artour())
    create index(:post_tags, [:tag_id], prefix: Grenadier.RepoPrefix.artour())
    create unique_index(:post_tags, [:post_id, :tag_id], name: "post_tag_unique_composite", prefix: Grenadier.RepoPrefix.artour())
  end
end
