defmodule Photog.Repo.Migrations.AddSourceImageIdToImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :source_image_id, references(:images, on_delete: :nothing)
    end
  end
end
