defmodule MovielistWeb.ReportsView do
  use MovielistWeb, :view

  def reports_for_current_year_score_sorted_path() do
    reports_for_year_path_score_sorted(Common.ModelHelpers.Date.today().year)
  end

  @doc """
  Returns a link to the reports for the given year
  """
  def reports_for_year_date_sorted_path(year) do
    reports_for_year_path(year, :date)
  end

  @doc """
  Returns a link to the reports for the given year
  with ratings sorted by score
  """
  def reports_for_year_path_score_sorted(year) do
    reports_for_year_path(year, :score)
  end

  defp reports_for_year_path(year, sort) do
    ~p"/reports/#{year}?sort=#{sort}"
  end
end
