defmodule Grenadier.Repo.Migrations.CreateLogins do
  use Ecto.Migration

  def change do
    create table(:logins) do
      add :attempt_time, :utc_datetime, null: false
      add :was_successful, :boolean, default: false, null: false
      add :username, :text
      add :ip, :text, null: false
      add :user_agent, :text

      timestamps()
    end

  end
end
