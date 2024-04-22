defmodule Grenadier.Repo.Migrations.BlockquoteCreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :first_name, :string, null: false
      add :middle_name, :string
      add :last_name, :string

      timestamps()
    end
    
    create unique_index(:authors, [:first_name, :middle_name, :last_name], name: :author_unique_name_index, prefix: Grenadier.RepoPrefix.blockquote())

  end
end
