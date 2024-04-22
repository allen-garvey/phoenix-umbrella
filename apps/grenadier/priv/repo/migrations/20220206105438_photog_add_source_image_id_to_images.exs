defmodule Grenadier.Repo.Migrations.PhotogAddSourceImageIdToImages do
  use Ecto.Migration

  def change do
    alter table(:images, prefix: Grenadier.RepoPrefix.photog()) do
      add :source_image_id, references(:images, on_delete: :nothing)
    end
  end
end
