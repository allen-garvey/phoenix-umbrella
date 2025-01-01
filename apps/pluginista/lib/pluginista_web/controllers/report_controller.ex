defmodule PluginistaWeb.ReportController do
  use PluginistaWeb, :controller
  alias Pluginista.Reports

  def index(conn, _params) do
    years = Reports.years_summary()
    plugins_count = years |> Enum.reduce(0, fn year, total -> year[:count] + total end)

    total_cost =
      years |> Enum.reduce(Decimal.new(0), fn year, total -> Decimal.add(total, year[:total]) end)

    spending_per_year =
      years
      |> Enum.map(fn %{year: year, total: total} ->
        {year, Decimal.to_float(total) |> Kernel./(200) |> Float.ceil() |> trunc()}
      end)
      |> Enum.reverse()

    render(conn, "index.html",
      years: years,
      plugins_count: plugins_count,
      total_cost: total_cost,
      spending_per_year: spending_per_year
    )
  end

  def makers_index(conn, _params) do
    render(conn, "makers.html")
  end
end
