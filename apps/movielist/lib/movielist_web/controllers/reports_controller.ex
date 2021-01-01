defmodule MovielistWeb.ReportsController do
  use MovielistWeb, :controller

  alias Movielist.Reports
  alias MovielistWeb.ReportsView

  def report_for_year(conn, year, sort) when is_integer(year) and is_atom(sort) do
    current_year = Common.ModelHelpers.Date.today().year

    if year > current_year or year < 1950 do
      invalid_year_redirect(conn)
    else
      rating_stats = Reports.rating_stats_for_year(year)
      ratings = Reports.list_ratings_for_year(year, sort)
      ratings_count_by_month = Reports.get_ratings_count_by_month(year, year == current_year)
      should_show_next_year = year < current_year

      render(conn, "show.html",
        page_atom: :reports_show,
        year: year,
        ratings: ratings,
        rating_count: rating_stats[:rating_count],
        average_score: rating_stats[:average_score],
        ratings_count_by_month: ratings_count_by_month,
        should_show_next_year: should_show_next_year
      )
    end
  end

  def show(conn, %{"year" => year_raw, "sort" => "date"}) do
    case Integer.parse(year_raw) do
      {year, _} -> report_for_year(conn, year, :date)
      _         -> invalid_year_redirect(conn)
    end
  end

  def show(conn, %{"year" => year_raw}) do
    case Integer.parse(year_raw) do
      {year, _} -> report_for_year(conn, year, :score)
      _         -> invalid_year_redirect(conn)
    end
  end

  def invalid_year_redirect(conn) do
    redirect(conn, to: ReportsView.reports_for_current_year_score_sorted_path(conn))
  end

end
