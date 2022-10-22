defmodule PluginistaWeb.PageController do
  use PluginistaWeb, :controller
  alias Pluginista.Reports

  def index(conn, _params) do
	resources_list = [
		{"Categories", :category_path},
		{"Groups", :group_path},
		{"Makers", :maker_path},
		{"Plugins", :plugin_path},
	]

	current_year = Common.ModelHelpers.Date.today().year
	current_year_summary = Reports.year_summary(current_year)

    render(conn, "index.html", resources: resources_list, current_year_summary: current_year_summary)
  end
end
