defmodule Booklist.Repo.Migrations.AddIsFictionToGenres do
  use Ecto.Migration

  def change do
    alter table(:genres) do
      add :is_fiction, :boolean, default: false, null: false
    end
  end
end
