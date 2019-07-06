defmodule Artour.Repo.Migrations.AddCoverImageToPostsTable do
  use Ecto.Migration

  def change do
  	alter table(:posts) do
      add :cover_image_id, references(:images, on_delete: :nothing)
    end
  end
end
