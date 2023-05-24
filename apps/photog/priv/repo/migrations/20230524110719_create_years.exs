defmodule Photog.Repo.Migrations.CreateYears do
  use Ecto.Migration

  def change do
    create table(:years, primary_key: false) do
      add :id, :integer, primary_key: true
      add :description, :text, null: false
    end
  end
end
