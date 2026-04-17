defmodule PluginistaWeb.PageController do
  use PluginistaWeb, :controller
  alias Pluginista.Reports

  plug(:put_view, html: PluginistaWeb.PageView)

  def index(conn, _params) do
    resources_list = [
      {"Categories", ~p"/categories"},
      {"Groups", ~p"/groups"},
      {"Makers", ~p"/makers"},
      {"Plugins", ~p"/plugins"}
    ]

    current_year = Common.ModelHelpers.Date.today().year
    current_year_summary = Reports.year_summary(current_year)

    render(conn, "index.html",
      resources: resources_list,
      current_year_summary: current_year_summary
    )
  end
end
