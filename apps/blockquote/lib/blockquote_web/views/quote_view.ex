defmodule BlockquoteWeb.QuoteView do
  use BlockquoteWeb, :view

  def index_path do
    ~p"/quotes"
  end

  def new_path do
    ~p"/quotes/new"
  end

  def show_path(quote) do
    ~p"/quotes/#{quote}"
  end

  def edit_path(quote) do
    ~p"/quotes/#{quote}/edit"
  end

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

  def item_columns(quote) do
    author = quote_author(quote)

    author_link =
      link(BlockquoteWeb.AuthorView.to_s(author), to: BlockquoteWeb.AuthorView.show_path(author))

    category_link =
      link(BlockquoteWeb.CategoryView.to_s(quote.category),
        to: BlockquoteWeb.CategoryView.show_path(quote.category)
      )

    source_link =
      link(BlockquoteWeb.SourceView.to_s(quote.source),
        to: BlockquoteWeb.SourceView.show_path(quote.source)
      )

    [
      {"body", quote.body},
      {"author", author_link},
      {"category", category_link},
      {"source", source_link},
      {"added", BlockquoteWeb.SharedView.item_date_created(quote)}
    ]
  end

  def form_action(nil) do
    index_path()
  end

  def form_action(quote) do
    show_path(quote)
  end
end
