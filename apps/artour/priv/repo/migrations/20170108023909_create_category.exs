defmodule Artour.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :slug, :string
      add :type, :integer

      timestamps()
    end

  end
end
