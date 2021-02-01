defmodule Booklist.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Booklist.Repo

  alias Booklist.Admin.Rating
  alias Booklist.Admin.Book

  @doc """
  Gets all ratings for given year
  """
  def get_ratings(year) do
    from(
      r in Rating, 
      join: book in assoc(r, :book), 
      preload: [book: book], 
      where: fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year, 
      order_by: [desc: r.score, desc: r.id]
    )
      |> Repo.all
  end

  def get_rating_statistics(year) do
  	from(r in Rating, where: fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year, select: %{count: count(r.id), average: coalesce(avg(r.score), 0)})
      |> Repo.one
  end

  def get_nonfiction_count(year) do
    book_subquery = from(
      b in Book
    )
    
    from(
      r in Rating, 
      select: count(r.id),
      left_join: book in subquery(book_subquery),
      on: book.id == r.book_id,
      where: fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year and book.is_fiction == false,
    )
    |> Repo.one
  end
  
  @doc """
  Gets the week number and number of ratings (books read) in that week for the given year
  How to group by using alias based on:
  https://angelika.me/2016/09/10/how-to-order-by-the-result-of-select-count-in-ecto/
  """
  def get_ratings_count_by_week_base_query(year) do
  	#need to create rating subquery or weeks with 0 ratings won't be returned
    rating_subquery = from(
      r in Rating,
      where: fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year,
      select: %{
        id: r.id,
        date_scored: r.date_scored,
      }
    )

    from(
      r in subquery(rating_subquery), 
      right_join: week_number in fragment("SELECT generate_series(1,53) AS week_number"), 
      on: fragment("week_number = extract(week FROM ?)", r.date_scored), 
      group_by: [fragment("week_number")], 
      select: %{
        week_number: fragment("week_number"), 
        count: count(r.id)
      }, 
      order_by: [fragment("week_number")]
    )
  end

  def get_ratings_count_by_week_query(year, should_limit) do
  	case should_limit do
  		#limit results only to weeks in current year
  		true  -> get_ratings_count_by_week_base_query(year) |> limit(fragment("SELECT EXTRACT(WEEK FROM current_timestamp)"))
  		false -> get_ratings_count_by_week_base_query(year)
  	end
  end


  @doc """
  Gets the week number and number of ratings (books read) in that week for the given year
  """
  def get_ratings_count_by_week(year, should_limit) when is_boolean(should_limit) do
  	get_ratings_count_by_week_query(year, should_limit)
  	  |> Repo.all	
  end


end