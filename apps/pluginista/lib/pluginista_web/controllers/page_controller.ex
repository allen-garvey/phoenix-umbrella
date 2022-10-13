defmodule PluginistaWeb.PageController do
  use PluginistaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def resources(conn, _params) do
  	resources_list = [
  		{"Categories", :category_path},
  		{"Groups", :group_path},
  		{"Makers", :maker_path},
  		{"Plugins", :plugin_path},
  	]

  	render(conn, "resources.html", resources: resources_list)
  end
end
