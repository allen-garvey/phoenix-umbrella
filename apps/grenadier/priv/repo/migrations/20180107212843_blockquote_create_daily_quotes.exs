defmodule Grenadier.Repo.Migrations.BlockquoteCreateDailyQuotes do
  use Ecto.Migration

  def change do
    create table(:daily_quotes, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :date_used, :date, null: false
      add :quote_id, references(:quotes, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:daily_quotes, [:quote_id], prefix: Grenadier.RepoPrefix.blockquote())
    create unique_index(:daily_quotes, [:quote_id, :date_used], name: :daily_quote_unique_index, prefix: Grenadier.RepoPrefix.blockquote())
  end
end
