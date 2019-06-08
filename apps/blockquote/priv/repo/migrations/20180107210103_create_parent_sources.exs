defmodule Blockquote.Repo.Migrations.CreateParentSources do
  use Ecto.Migration

  def change do
    create table(:parent_sources) do
      add :title, :string, null: false
      add :subtitle, :string
      add :url, :string
      add :source_type_id, references(:source_types, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:parent_sources, [:source_type_id])
  end
end
