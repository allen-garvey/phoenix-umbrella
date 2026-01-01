defmodule BooklistWeb.ReportsView do
  use BooklistWeb, :view

  @doc """
  Returns a link to the reports for the current year
  """
  def reports_for_current_year_path(conn) do
    current_year = Common.ModelHelpers.Date.today().year
    reports_for_year_path(conn, current_year)
  end

  @doc """
  Returns a link to the reports for the given year
  """
  def reports_for_year_path(conn, year) do
    Routes.reports_path(conn, :years_show, year)
  end

  def normalize_books_per_year_count(years) do
    max_count = Enum.max_by(years, fn {_year, count} -> count end, &>=/2, fn -> 0 end)

    divisor =
      cond do
        max_count <= 24 -> 1
        max_count <= 99 -> 5
        true -> 10
      end

    Enum.map(years, fn {year, count} -> {year, Integer.floor_div(count, divisor)} end)
  end
end
