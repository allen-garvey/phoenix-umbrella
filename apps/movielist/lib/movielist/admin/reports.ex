defmodule Movielist.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Movielist.Repo

  alias Movielist.Admin
  # alias Movielist.Admin.Genre
  alias Movielist.Admin.Movie
  alias Movielist.Admin.Rating

  @doc """
  Returns map with count of movies for genre id and their average pre-rating
  """
  def movie_stats_for_genre(genre_id) do
    from(m in Movie, where: m.genre_id == ^genre_id, select: %{movie_count: count(m), average_pre_rating: avg(m.pre_rating)})
    |> Repo.one!
  end

  @doc """
  Returns map with count of rated movies for genre id and their average score
  """
  def rating_stats_for_genre(genre_id) do
    from(r in Rating, join: m in assoc(r, :movie), where: m.genre_id == ^genre_id, select: %{rating_count: count(r), average_score: avg(r.score)})
    |> Repo.one!
  end

  @doc """
  Returns map with count of rated movies for year and their average score
  """
  def rating_stats_for_year(year) do
    from(r in Rating, join: m in assoc(r, :movie), where: fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year, select: %{rating_count: count(r), average_score: coalesce(avg(r.score), 0)})
    |> Repo.one!
  end

  @doc """
  Base query for ratings by year
  """
  def list_ratings_for_year_base_query(year) do
    Admin.list_ratings_base_query()
    |> where([r], fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year)
  end

  @doc """
  Returns list of ratings by year
  """
  def list_ratings_for_year(year, :date) do
    list_ratings_for_year_base_query(year)
    |> order_by(asc: :date_scored, asc: :id, desc: :score)
    |> Repo.all
  end

  def list_ratings_for_year(year, :score) do
    list_ratings_for_year_base_query(year)
    |> order_by(desc: :score, asc: :date_scored, asc: :id)
    |> Repo.all
  end

  @doc """
  Gets the month number and number of ratings (movies watched) in that month for the given year
  """
  def get_ratings_count_by_month_base_query(year) do
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
      right_join: month_number in fragment("SELECT generate_series(1,12) AS month_number"), 
      on: fragment("month_number = extract(month FROM ?)", r.date_scored), 
      group_by: [fragment("month_number")], 
      select: %{
        month_number: fragment("month_number"), 
        count: count(r.id)
      }, 
      order_by: [fragment("month_number")]
    )
  end

  def get_ratings_count_by_month_query(year, should_limit) do
    case should_limit do
      #limit results only to weeks in current year
      true  -> get_ratings_count_by_month_base_query(year) |> limit(fragment("SELECT EXTRACT(MONTH FROM current_timestamp)"))
      false -> get_ratings_count_by_month_base_query(year)
    end
  end


  @doc """
  Gets the week number and number of ratings (books read) in that week for the given year
  """
  def get_ratings_count_by_month(year, should_limit) when is_boolean(should_limit) do
    get_ratings_count_by_month_query(year, should_limit)
      |> Repo.all 
  end

end
