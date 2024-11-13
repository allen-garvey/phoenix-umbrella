defmodule BlockquoteWeb.DailyQuoteView do
  use BlockquoteWeb, :view
  alias BlockquoteWeb.SharedView
  
  def to_s(daily_quote) do
    "#{Date.to_iso8601(daily_quote.date_used)} — #{BlockquoteWeb.QuoteView.to_short_excerpt(daily_quote.quote)}"
  end
  
  def item_columns(conn, daily_quote) do
    quote_link = link(BlockquoteWeb.QuoteView.to_short_excerpt(daily_quote.quote), to: quote_path(conn, :show, daily_quote.quote))
    [
        {"date used", Date.to_iso8601(daily_quote.date_used)}, 
        {"quote", quote_link},
        {"added", SharedView.item_date_created(daily_quote)},
    ]
  end
  
  def form_action(conn, nil) do
    daily_quote_path(conn, :create)
  end

  def form_action(conn, daily_quote) do
    daily_quote_path(conn, :update, daily_quote)
  end
end
