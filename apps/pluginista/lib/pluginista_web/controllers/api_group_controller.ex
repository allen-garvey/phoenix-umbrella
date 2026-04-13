defmodule PluginistaWeb.ApiGroupController do
  use PluginistaWeb, :controller

  alias Pluginista.Admin

  plug(:put_view, json: PluginistaWeb.ApiGroupView)

  def index(conn, _params) do
    groups = Admin.list_groups()
    render(conn, "index.json", groups: groups)
  end
end
