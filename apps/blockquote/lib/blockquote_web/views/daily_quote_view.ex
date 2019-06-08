defmodule BlockquoteWeb.DailyQuoteView do
  use BlockquoteWeb, :view
  alias BlockquoteWeb.SharedView
  
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, shared_form_assigns(assigns))
    render BlockquoteWeb.SharedView, "new.html", assigns
  end

  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, 
      %{
        item_display_name: "Daily quote"
      }
    ) |> Map.merge(shared_form_assigns(assigns))
    render BlockquoteWeb.SharedView, "edit.html", assigns
  end

  def shared_form_assigns(assigns) do
    %{
        required_fields: Blockquote.Admin.DailyQuote.required_fields(), 
        form_fields: form_fields(assigns[:related_fields])
      }
  end
  
  def to_s(daily_quote) do
    "#{SharedView.date_to_iso_string(daily_quote.date_used)} — #{BlockquoteWeb.QuoteView.to_short_excerpt(daily_quote.quote)}"
  end
  
  def item_columns(conn, daily_quote) do
    quote_link = link(BlockquoteWeb.QuoteView.to_short_excerpt(daily_quote.quote), to: quote_path(conn, :show, daily_quote.quote))
    [
        {"date used", SharedView.date_to_iso_string(daily_quote.date_used)}, 
        {"quote", quote_link},
        {"added", SharedView.item_date_created(daily_quote)},
    ]
  end
  
  def form_fields(related_fields) do
    [
      {:date_used, :date, nil},
      {:quote_id, :select, related_fields[:quotes]},
    ]
  end
end
