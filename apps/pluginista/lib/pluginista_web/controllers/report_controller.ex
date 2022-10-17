defmodule PluginistaWeb.ReportController do
    use PluginistaWeb, :controller
  
    def index(conn, _params) do
        years = Pluginista.Reports.years_summary()
        render(conn, "index.html", years: years)
    end
end
  