defmodule Grenadier.Repo.Migrations.PhotogCreateYears do
  use Ecto.Migration

  def change do
    create table(:years, primary_key: false, prefix: Grenadier.RepoPrefix.photog()) do
      add :id, :integer, primary_key: true
      add :description, :text
      add :album_id, references(:albums, on_delete: :nothing)
    end
  end
end
