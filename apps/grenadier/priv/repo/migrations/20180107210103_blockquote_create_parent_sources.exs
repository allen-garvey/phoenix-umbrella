defmodule Grenadier.Repo.Migrations.BlockquoteCreateParentSources do
  use Ecto.Migration

  def change do
    create table(:parent_sources, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :title, :string, null: false
      add :subtitle, :string
      add :url, :string
      add :source_type_id, references(:source_types, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:parent_sources, [:source_type_id], prefix: Grenadier.RepoPrefix.blockquote())
  end
end
