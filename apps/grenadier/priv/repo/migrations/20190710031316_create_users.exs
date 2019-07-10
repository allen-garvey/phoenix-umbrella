defmodule Grenadier.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :text, null: false
      add :password_hash, :text, null: false

      timestamps()
    end

    create unique_index(:users, [:name])

  end
end
