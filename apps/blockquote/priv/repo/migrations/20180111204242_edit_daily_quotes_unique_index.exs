defmodule Blockquote.Repo.Migrations.EditDailyQuotesUniqueIndex do
  use Ecto.Migration

  def change do
    drop index(:daily_quotes, [:quote_id, :date_used], name: :daily_quote_unique_index)
    create unique_index(:daily_quotes, [:date_used])
  end
end
