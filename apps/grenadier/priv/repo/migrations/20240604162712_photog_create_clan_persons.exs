defmodule Grenadier.Repo.Migrations.PhotogCreateClanPersons do
    use Ecto.Migration
  
    def change do
      create table(:clan_persons, prefix: Grenadier.RepoPrefix.photog(), primary_key: false) do
        add :clan_id, references(:clans, on_delete: :delete_all), primary_key: true
        add :person_id, references(:persons, on_delete: :delete_all), primary_key: true
      end
    end
end
  