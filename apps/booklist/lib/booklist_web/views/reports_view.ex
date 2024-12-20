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

  def ratings_by_week_chart_item_class(rating_count, current_count)
      when is_integer(rating_count) and is_integer(current_count) do
    case rating_count >= current_count do
      true -> "count-filled"
      false -> ""
    end
  end
end
