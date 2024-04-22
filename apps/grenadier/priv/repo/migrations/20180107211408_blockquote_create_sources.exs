defmodule Grenadier.Repo.Migrations.BlockquoteCreateSources do
  use Ecto.Migration

  def change do
    create table(:sources, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :title, :string, null: false
      add :subtitle, :string
      add :url, :string
      add :author_id, references(:authors, on_delete: :nothing), null: false
      add :source_type_id, references(:source_types, on_delete: :nothing), null: false
      add :parent_source_id, references(:parent_sources, on_delete: :nothing)

      timestamps()
    end

    create index(:sources, [:author_id], prefix: Grenadier.RepoPrefix.blockquote())
    create index(:sources, [:source_type_id], prefix: Grenadier.RepoPrefix.blockquote())
    create index(:sources, [:parent_source_id], prefix: Grenadier.RepoPrefix.blockquote())
  end
end
