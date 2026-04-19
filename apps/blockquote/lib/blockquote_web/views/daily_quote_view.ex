defmodule BlockquoteWeb.DailyQuoteView do
  use BlockquoteWeb, :view
  alias BlockquoteWeb.SharedView

  def index_path do
    ~p"/daily-quotes"
  end

  def new_path do
    ~p"/daily-quotes/new"
  end

  def show_path(daily_quote) do
    ~p"/daily-quotes/#{daily_quote}"
  end

  def edit_path(daily_quote) do
    ~p"/daily-quotes/#{daily_quote}/edit"
  end

  def to_s(daily_quote) do
    "#{Date.to_iso8601(daily_quote.date_used)} — #{BlockquoteWeb.QuoteView.to_short_excerpt(daily_quote.quote)}"
  end

  def item_columns(daily_quote) do
    quote_link =
      link(BlockquoteWeb.QuoteView.to_short_excerpt(daily_quote.quote),
        to: BlockquoteWeb.QuoteView.show_path(daily_quote.quote)
      )

    [
      {"date used", Date.to_iso8601(daily_quote.date_used)},
      {"quote", quote_link},
      {"added", SharedView.item_date_created(daily_quote)}
    ]
  end

  def form_action(nil) do
    index_path()
  end

  def form_action(daily_quote) do
    show_path(daily_quote)
  end
end
