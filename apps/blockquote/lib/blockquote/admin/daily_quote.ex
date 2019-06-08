defmodule Blockquote.Admin.DailyQuote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.DailyQuote


  schema "daily_quotes" do
    field :date_used, :date

    timestamps()
    
    belongs_to :quote, Blockquote.Admin.Quote
  end
  
  def required_fields() do
    [:date_used, :quote_id]
  end

  @doc false
  def changeset(%DailyQuote{} = daily_quote, attrs) do
    daily_quote
    |> cast(attrs, [:date_used, :quote_id])
    |> validate_required(required_fields())
    |> unique_constraint(:date_used)
  end
end
