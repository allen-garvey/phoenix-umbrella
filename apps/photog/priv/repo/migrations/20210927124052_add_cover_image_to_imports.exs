defmodule Photog.Repo.Migrations.AddCoverImageToImports do
  use Ecto.Migration

  def change do
    alter table(:imports) do
      add :cover_image_id, references(:images, on_delete: :nothing)
    end
  end
end
