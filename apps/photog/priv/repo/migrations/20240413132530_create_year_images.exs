defmodule Photog.Repo.Migrations.CreateYearImages do
  use Ecto.Migration

  def change do
    create table(:year_images) do
      add :year, :integer
      add :image_id, references(:images, on_delete: :nothing)

    end

    create index(:year_images, [:image_id])
    create index(:year_images, [:year])
  end
end
