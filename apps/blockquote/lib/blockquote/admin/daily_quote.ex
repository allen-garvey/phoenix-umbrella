defmodule Blockquote.Admin.DailyQuote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.DailyQuote

  @schema_prefix Grenadier.RepoPrefix.blockquote()
  schema "daily_quotes" do
    field :date_used, :date

    timestamps()
    
    belongs_to :quote, Blockquote.Admin.Quote
  end

  @doc false
  def changeset(%DailyQuote{} = daily_quote, attrs) do
    daily_quote
    |> cast(attrs, [:date_used, :quote_id])
    |> validate_required([:date_used, :quote_id])
    |> unique_constraint(:date_used)
  end
end
