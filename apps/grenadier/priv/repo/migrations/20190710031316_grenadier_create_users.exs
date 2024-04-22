defmodule Grenadier.Repo.Migrations.GrenadierCreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, prefix: Grenadier.RepoPrefix.grenadier()) do
      add :name, :text, null: false
      add :password_hash, :text, null: false

      timestamps()
    end

    create unique_index(:users, [:name], prefix: Grenadier.RepoPrefix.grenadier())

  end
end
