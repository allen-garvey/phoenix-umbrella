defmodule Grenadier.Repo.Migrations.BlockquoteEditDailyQuotesUniqueIndex do
  use Ecto.Migration

  def change do
    drop index(:daily_quotes, [:quote_id, :date_used], name: :daily_quote_unique_index, prefix: Grenadier.RepoPrefix.blockquote())
    create unique_index(:daily_quotes, [:date_used], prefix: Grenadier.RepoPrefix.blockquote())
  end
end
