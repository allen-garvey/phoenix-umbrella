defmodule Blockquote.Repo.Migrations.CreateDailyQuotes do
  use Ecto.Migration

  def change do
    create table(:daily_quotes) do
      add :date_used, :date, null: false
      add :quote_id, references(:quotes, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:daily_quotes, [:quote_id])
    create unique_index(:daily_quotes, [:quote_id, :date_used], name: :daily_quote_unique_index)
  end
end
