defmodule Artour.Repo.Migrations.CreatePostImage do
  use Ecto.Migration

  def change do
    create table(:post_images) do
      add :order, :integer
      add :caption, :text
      add :post_id, references(:posts, on_delete: :delete_all)
      add :image_id, references(:images, on_delete: :delete_all)

      timestamps()
    end
    create index(:post_images, [:post_id])
    create index(:post_images, [:image_id])
    create unique_index(:post_images, [:post_id, :image_id], name: "post_image_unique_composite")
  end
end
