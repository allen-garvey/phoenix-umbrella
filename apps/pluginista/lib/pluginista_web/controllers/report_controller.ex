defmodule PluginistaWeb.ReportController do
    use PluginistaWeb, :controller
    alias Pluginista.Reports
  
    def index(conn, _params) do
        years = Reports.years_summary()
        plugins_count = years |> Enum.reduce(0, fn year, total -> year[:count] + total end)
        total_cost = years |> Enum.reduce(Decimal.new(0), fn year, total -> Decimal.add(total, year[:total]) end)
        
        render(conn, "index.html", years: years, plugins_count: plugins_count, total_cost: total_cost)
    end

    def makers_index(conn, _params) do
        render(conn, "makers.html")
    end
end
  