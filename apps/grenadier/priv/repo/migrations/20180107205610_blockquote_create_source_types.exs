defmodule Grenadier.Repo.Migrations.BlockquoteCreateSourceTypes do
  use Ecto.Migration

  def change do
    create table(:source_types, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :name, :string, null: false

      timestamps()
    end
    create unique_index(:source_types, [:name], prefix: Grenadier.RepoPrefix.blockquote())
  end
end
