defmodule BooklistWeb.ReportsView do
  use BooklistWeb, :view

  @doc """
  Returns a link to the reports for the current year
  """
  def reports_for_current_year_path() do
    current_year = Common.ModelHelpers.Date.today().year
    reports_for_year_path(current_year)
  end

  @doc """
  Returns a link to the reports for the given year
  """
  def reports_for_year_path(year) do
    ~p"/reports/years/#{year}"
  end
end
