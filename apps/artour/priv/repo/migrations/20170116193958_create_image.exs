defmodule Artour.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :title, :string
      add :description, :string
      add :filename_large, :string
      add :filename_medium, :string
      add :filename_small, :string
      add :filename_thumbnail, :string
      add :completion_date, :date
      add :format_id, references(:formats, on_delete: :nothing)

      timestamps()
    end
    create index(:images, [:format_id])
    create unique_index(:images, [:title])
  end
end
