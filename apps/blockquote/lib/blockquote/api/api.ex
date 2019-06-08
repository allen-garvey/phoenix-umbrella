defmodule Blockquote.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Blockquote.Repo

  alias Blockquote.Admin.Quote
  alias Blockquote.Admin.DailyQuote

  @doc """
  Gets a single random quote.

  Raises `Ecto.NoResultsError` if the Daily quote table is empty

  """
  def get_random_quote!() do 
    Repo.one!(from(Quote, order_by: fragment("random()"), limit: 1))
      |> Repo.preload([ :author, :category, {:source, [:author, :parent_source]} ])
  end

  @doc """
  Gets a single daily quote for today's date if there is one already saved or nil

  """
  def get_todays_daily_quote() do 
    Repo.one(from(d in DailyQuote, where: d.date_used == ^Date.utc_today, limit: 1))
      |> Repo.preload([ {:quote, [:author, :category, {:source, [:author, :parent_source]}]} ])
  end

end
