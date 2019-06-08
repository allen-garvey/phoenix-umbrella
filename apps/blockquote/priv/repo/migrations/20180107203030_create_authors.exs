defmodule Blockquote.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :first_name, :string, null: false
      add :middle_name, :string
      add :last_name, :string

      timestamps()
    end
    
    create unique_index(:authors, [:first_name, :middle_name, :last_name], name: :author_unique_name_index)

  end
end
