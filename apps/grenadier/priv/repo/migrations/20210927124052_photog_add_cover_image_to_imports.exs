defmodule Grenadier.Repo.Migrations.PhotogAddCoverImageToImports do
  use Ecto.Migration

  def change do
    alter table(:imports, prefix: Grenadier.RepoPrefix.photog()) do
      add :cover_image_id, references(:images, on_delete: :nothing)
    end
  end
end
