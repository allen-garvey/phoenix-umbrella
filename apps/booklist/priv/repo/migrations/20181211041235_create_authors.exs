defmodule Booklist.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :first_name, :text, null: false
      add :middle_name, :text
      add :last_name, :text

      timestamps()
    end

  end
end
