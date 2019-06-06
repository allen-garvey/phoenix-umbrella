defmodule BooklistWeb.ReportsController do
  use BooklistWeb, :controller

  alias Booklist.Reports

  def report_for_year(conn, year) when is_integer(year) do
    rating_stats = Reports.get_rating_statistics(year)
    lowest_rating = Reports.get_lowest_rating(year)
    top_ratings = Reports.get_top_ratings(year, 10)
    highest_rating = case Enum.fetch(top_ratings, 0) do
      {:ok, rating} -> rating
      _             -> nil
    end
    ratings_count_by_week = Reports.get_ratings_count_by_week(year, year == Date.utc_today.year)

    render(conn, "show.html", year: year, rating_stats: rating_stats, lowest_rating: lowest_rating, highest_rating: highest_rating, top_ratings: top_ratings, ratings_count_by_week: ratings_count_by_week)
  end

  def show(conn, %{"year" => year_raw}) do
    case Integer.parse(year_raw) do
      {year, _} -> report_for_year(conn, year)
      _         -> redirect(conn, to: BooklistWeb.ReportsView.reports_for_current_year_path(conn))
    end
  end

  
end
