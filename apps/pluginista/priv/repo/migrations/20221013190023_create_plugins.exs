defmodule Pluginista.Repo.Migrations.CreatePlugins do
  use Ecto.Migration

  def change do
    create table(:plugins) do
      add :name, :text
      add :acquisition_date, :date
      add :cost, :decimal
      add :group_id, references(:groups, on_delete: :nothing), null: false
      add :maker_id, references(:makers, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
