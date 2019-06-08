defmodule Blockquote.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :body, :text, null: false
      add :author_id, references(:authors, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing), null: false
      add :source_id, references(:sources, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:quotes, [:author_id])
    create index(:quotes, [:category_id])
    create index(:quotes, [:source_id])
  end
end
