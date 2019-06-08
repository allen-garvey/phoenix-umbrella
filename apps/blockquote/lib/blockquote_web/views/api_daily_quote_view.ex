defmodule BlockquoteWeb.ApiDailyQuoteView do
  use BlockquoteWeb, :view

  def render("show.json", %{quote: quote}) do
    %{data: render_one(quote, __MODULE__, "quote.json", as: :quote)}
  end

  def render("quote.json", %{quote: quote}) do
  	quote_author = author_for_quote(quote.author, quote.source.author)
    %{
    	id: quote.id,
    	body: quote.body,
    	source: %{
    		title: quote.source.title,
    		parent_title: parent_source_title(quote.source.parent_source),
    	},
    	category: quote.category.name,
    	author: %{
    		first_name: quote_author.first_name,
    		middle_name: quote_author.middle_name,
    		last_name: quote_author.last_name,
    		display_name: author_display_name(quote_author)
    	},
	}
  end

  #returns the author for a quote
  #because a quote author might be nil, but the source author should never be nil
  def author_for_quote(nil, source_author) do
  	source_author
  end
  def author_for_quote(quote_author, _source_author) do 
  	quote_author
  end

  def parent_source_title(nil) do
  	nil
  end
  def parent_source_title(parent_source) do
  	parent_source.title
  end

  def author_display_name(author) do
  	first_name = initialize_name(author.first_name)
	middle_name = initialize_name(author.middle_name)
	last_name = initialize_name(author.last_name)

	[first_name, middle_name, last_name] |> Enum.filter(fn x -> !is_nil(x) end) |> Enum.join(" ")
  end


  def initialize_name(name) do
  	cond do
		is_nil(name) ->
			nil
		String.length(name) == 1 ->
			name <> "."
		true ->
			name
	end
  end
end