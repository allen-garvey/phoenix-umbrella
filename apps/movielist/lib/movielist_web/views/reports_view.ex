defmodule MovielistWeb.ReportsView do
  use MovielistWeb, :view

  @doc """
  Returns a link to the reports for the current year
  """
  def reports_for_current_year_date_sorted_path(conn) do
    reports_for_year_date_sorted_path(conn, Common.ModelHelpers.Date.today().year)
  end

  def reports_for_current_year_score_sorted_path(conn) do
    reports_for_year_path_score_sorted(conn, Common.ModelHelpers.Date.today().year)
  end

  @doc """
  Returns a link to the reports for the given year
  """
  def reports_for_year_date_sorted_path(conn, year) do
    reports_for_year_path(conn, year, :date)
  end

  @doc """
  Returns a link to the reports for the given year
  with ratings sorted by score
  """
  def reports_for_year_path_score_sorted(conn, year) do
    reports_for_year_path(conn, year, :score)
  end

  @doc """
  Returns a link to the reports for the given year
  with ratings sorted by sort
  valid sort options are date or score
  """
  def reports_for_year_path(conn, year, sort) do
    Routes.reports_path(conn, :show, year, sort: sort)
  end
end
