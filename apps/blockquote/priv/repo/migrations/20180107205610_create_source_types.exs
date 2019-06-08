defmodule Blockquote.Repo.Migrations.CreateSourceTypes do
  use Ecto.Migration

  def change do
    create table(:source_types) do
      add :name, :string, null: false

      timestamps()
    end
    create unique_index(:source_types, [:name])
  end
end
