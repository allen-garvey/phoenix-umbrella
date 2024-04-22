defmodule Grenadier.Repo.Migrations.ArtourCreatePost do
  use Ecto.Migration

  def change do
    create table(:posts, prefix: Grenadier.RepoPrefix.artour()) do
      add :title, :text
      add :slug, :text
      add :body, :text
      add :is_published, :boolean, default: true, null: false
  		add :publication_date, :date
      add :is_markdown, :boolean, default: false, null: false
      add :is_nsfw, :boolean, default: false
      add :category_id, references(:categories, on_delete: :nothing)
      add :cover_image_id, references(:images, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:category_id], prefix: Grenadier.RepoPrefix.artour())
    create unique_index(:posts, [:title], prefix: Grenadier.RepoPrefix.artour())
  	create unique_index(:posts, [:slug], prefix: Grenadier.RepoPrefix.artour())

  end
end
