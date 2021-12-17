defmodule BooklistWeb.ReportsController do
  use BooklistWeb, :controller

  alias Booklist.Reports

  def report_for_year(conn, year, current_year) when is_integer(year) do
    ratings_task = Task.async(fn -> Reports.get_ratings(year) end)
    genres_task = Task.async(fn -> Reports.get_genres() end)
    
    ratings = Task.await(ratings_task)
    ratings_count = Enum.count(ratings)
    average_rating = Reports.calculate_rating_total(ratings)  / 100
      |> Reports.calculate_percent_of_ratings(ratings_count)
    highest_rating = Enum.at(ratings, 0)
    lowest_rating = Enum.at(ratings, -1)
    ratings_count_by_week = Reports.calculate_ratings_by_week(ratings, year < current_year)
    books_per_week_average = ratings_count / Enum.count(ratings_count_by_week) |> Float.round(2)
    nonfiction_percent = Reports.calculate_nonfiction_count(ratings)
      |> Reports.calculate_percent_of_ratings(ratings_count)
    genres_count = Task.await(genres_task) |> Reports.calculate_genres_count(ratings, ratings_count)

    render(conn, "show.html",
      year: year,
      ratings_count: ratings_count,
      average_rating: average_rating,
      lowest_rating: lowest_rating,
      highest_rating: highest_rating,
      nonfiction_percent: nonfiction_percent,
      books_per_week_average: books_per_week_average,
      ratings: ratings,
      genres_count: genres_count,
      ratings_count_by_week: ratings_count_by_week,
      should_show_next_year: year < current_year
    )
  end

  def report_for_year_helper(conn, year) do
    current_year = Common.ModelHelpers.Date.today().year
    if year <= current_year and year > 1950 do
      report_for_year(conn, year, current_year)
    else
      invalid_year_redirect(conn)
    end
  end

  def invalid_year_redirect(conn) do
    redirect(conn, to: BooklistWeb.ReportsView.reports_for_current_year_path(conn))
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def years_show(conn, %{"year" => year_raw}) do
    case Integer.parse(year_raw) do
      {year, _} -> report_for_year_helper(conn, year)
      _         -> invalid_year_redirect(conn)
    end
  end

  def authors_index(conn, _params) do
    authors = Reports.list_authors() |> Reports.calculate_authors_average_score
    render(conn, "authors.html", authors: authors)
  end

end
