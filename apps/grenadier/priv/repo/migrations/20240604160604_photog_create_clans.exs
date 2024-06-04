defmodule Grenadier.Repo.Migrations.PhotogCreateClans do
    use Ecto.Migration
  
    def change do
      create table(:clans, prefix: Grenadier.RepoPrefix.photog()) do
        add :name, :text
  
        timestamps()
      end

      create unique_index(:clans, [:name], prefix: Grenadier.RepoPrefix.photog())
    end
  end
  