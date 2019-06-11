defmodule Bookmarker.Repo.Migrations.CreateFolder do
  use Ecto.Migration

  def change do
    create table(:folders) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
