defmodule PluginistaWeb.ApiReportController do
    use PluginistaWeb, :controller
    alias Pluginista.Reports
  
    def makers_index(conn, _params) do
        makers = Reports.makers_stats()
        render(conn, "makers.json", conn: conn, makers: makers)
    end
end
  