defmodule BlockquoteWeb.QuoteView do
  use BlockquoteWeb, :view
  
  def to_excerpt(quote) do
    to_excerpt(quote, 130)
  end
  
  def to_short_excerpt(quote) do
    to_excerpt(quote, 25)
  end
  
  def to_excerpt(quote, max_length) do
    if String.length(quote.body) > max_length do
        quote.body |> String.slice(0, max_length) |> Kernel.<>("…")
    else
        quote.body
    end
  end
  
  def quote_author(quote) do
    if !is_nil(quote.author) do
      quote.author
    else
      quote.source.author
    end
  end
  
  @doc """
  Maps a list of quotes into tuples, used for forms
  """
  def map_for_form(quotes) do
    Enum.map(quotes, &{to_short_excerpt(&1), &1.id})
  end
  
  def item_columns(conn, quote) do
    author = quote_author(quote)
    author_link = link(BlockquoteWeb.AuthorView.to_s(author), to: author_path(conn, :show, author))
    category_link = link(BlockquoteWeb.CategoryView.to_s(quote.category), to: category_path(conn, :show, quote.category))
    source_link = link(BlockquoteWeb.SourceView.to_s(quote.source), to: source_path(conn, :show, quote.source))
    
    [
      {"body", quote.body}, 
      {"author", author_link}, 
      {"category", category_link},
      {"source", source_link},
      {"added", BlockquoteWeb.SharedView.item_date_created(quote)},
    ]
  end

  def form_action(conn, nil) do
    quote_path(conn, :create)
  end

  def form_action(conn, quote) do
    quote_path(conn, :update, quote)
  end
end
