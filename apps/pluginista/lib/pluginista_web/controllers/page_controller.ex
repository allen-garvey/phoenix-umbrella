defmodule PluginistaWeb.PageController do
  use PluginistaWeb, :controller
  alias Pluginista.Reports

  def index(conn, _params) do
	resources_list = [
		{"Categories", Routes.category_path(conn, :index)},
		{"Groups", Routes.group_path(conn, :index)},
		{"Makers", Routes.maker_path(conn, :index)},
		{"Plugins", Routes.plugin_path(conn, :index)},
	]

	current_year = Common.ModelHelpers.Date.today().year
	current_year_summary = Reports.year_summary(current_year)

    render(conn, "index.html", resources: resources_list, current_year_summary: current_year_summary)
  end
end
