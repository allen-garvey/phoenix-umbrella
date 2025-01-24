defmodule Blockquote.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Blockquote.Admin.Quote
  alias Blockquote.Admin.DailyQuote

  @doc """
  Gets a single random quote.

  Raises `Ecto.NoResultsError` if the Daily quote table is empty

  """
  def get_random_quote!() do
    from(
      q in Quote,
      join: author in assoc(q, :author),
      join: category in assoc(q, :category),
      join: source in assoc(q, :source),
      join: source_author in assoc(source, :author),
      left_join: parent_source in assoc(source, :parent_source),
      preload: [
        author: author,
        category: category,
        source: {source, [author: source_author, parent_source: parent_source]}
      ],
      order_by: fragment("random()"),
      limit: 1
    )
    |> Repo.one!()
  end

  @doc """
  Gets a single daily quote for today's date if there is one already saved or nil

  """
  def get_todays_daily_quote() do
    from(
      daily_quote in DailyQuote,
      join: q in assoc(daily_quote, :quote),
      join: author in assoc(q, :author),
      join: category in assoc(q, :category),
      join: source in assoc(q, :source),
      join: source_author in assoc(source, :author),
      left_join: parent_source in assoc(source, :parent_source),
      preload: [
        quote:
          {q,
           [
             author: author,
             category: category,
             source: {source, [author: source_author, parent_source: parent_source]}
           ]}
      ],
      where: daily_quote.date_used == ^Common.ModelHelpers.Date.today(),
      limit: 1
    )
    |> Repo.one()
  end
end
