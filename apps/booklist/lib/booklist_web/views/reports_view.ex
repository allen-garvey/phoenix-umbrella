defmodule BooklistWeb.ReportsView do
  use BooklistWeb, :view

  @doc """
  Returns a link to the reports for the current year
  """
  def reports_for_current_year_path(conn) do
    current_year = Date.utc_today.year
    reports_for_year_path(conn, current_year)
  end

  @doc """
  Returns a link to the reports for the given year
  """
  def reports_for_year_path(conn, year) do
    Routes.reports_path(conn, :show, year)
  end

  @doc """
  Rounds decimal
  """
  def round_decimal(decimal) do
    decimal
      |> Decimal.to_float 
      |> Float.round(2)
  end

  @doc """
  Returns database results as json string
  """
  def ratings_by_week_to_json(results) do
    results 
      |> Enum.map(fn result -> [Integer.to_string(result[:week_number]), result[:count]] end)
      |> Poison.encode!
  end

end
