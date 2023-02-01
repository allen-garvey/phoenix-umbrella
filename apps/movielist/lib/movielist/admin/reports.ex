defmodule Movielist.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Movielist.Repo

  alias Movielist.Admin
  alias Movielist.Admin.Movie
  alias Movielist.Admin.Rating

  def increment(num) do
    num + 1
  end

  def calculate_percent_of_ratings(total, ratings_count) do
    total / max(ratings_count, 1) |> Float.round(2)
  end

  def calculate_rating_total(ratings) do
    Enum.reduce(ratings, 0, fn (rating, total) -> total + rating.score end)
  end

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
  def calculate_ratings_per_month(ratings, is_current_year) do
    end_month = case is_current_year do
      true -> Common.ModelHelpers.Date.today.month
      false -> 12
    end
    month_map = ratings
      |> Enum.reduce(Map.new, fn (rating, month_map) ->  
        Map.update(month_map, rating.date_scored.month, 1, &increment/1) end)
    1..end_month
      |> Enum.map(fn (month_number) -> %{month_number: month_number, count: month_map[month_number]} end)
  end

end
