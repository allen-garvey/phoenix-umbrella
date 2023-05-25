defmodule Photog.Repo.Migrations.AddCoverImageToYears do
  use Ecto.Migration

  def change do
    alter table(:years) do
      modify :description, :text, null: true
      add :cover_image_id, references(:images, on_delete: :nothing)
    end
  end
end
