defmodule Artour.Repo.Migrations.CreatePostTag do
  use Ecto.Migration

  def change do
    create table(:post_tags) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)

      timestamps()
    end
    create index(:post_tags, [:post_id])
    create index(:post_tags, [:tag_id])
    create unique_index(:post_tags, [:post_id, :tag_id], name: "post_tag_unique_composite")
  end
end
