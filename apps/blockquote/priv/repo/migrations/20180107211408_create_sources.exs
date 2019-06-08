defmodule Blockquote.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources) do
      add :title, :string, null: false
      add :subtitle, :string
      add :url, :string
      add :author_id, references(:authors, on_delete: :nothing), null: false
      add :source_type_id, references(:source_types, on_delete: :nothing), null: false
      add :parent_source_id, references(:parent_sources, on_delete: :nothing)

      timestamps()
    end

    create index(:sources, [:author_id])
    create index(:sources, [:source_type_id])
    create index(:sources, [:parent_source_id])
  end
end
