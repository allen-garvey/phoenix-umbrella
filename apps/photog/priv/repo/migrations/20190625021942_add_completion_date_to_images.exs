defmodule Photog.Repo.Migrations.AddCompletionDateToImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :completion_date, :date
    end
  end
end
