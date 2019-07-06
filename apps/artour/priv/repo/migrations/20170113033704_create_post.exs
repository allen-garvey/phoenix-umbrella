defmodule Artour.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :text
      add :slug, :text
      add :body, :text
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:category_id])

  end
end
