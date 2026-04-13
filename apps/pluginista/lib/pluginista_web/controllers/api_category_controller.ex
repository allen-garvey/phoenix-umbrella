defmodule PluginistaWeb.ApiCategoryController do
  use PluginistaWeb, :controller

  alias Pluginista.Api

  plug(:put_view, json: PluginistaWeb.ApiCategoryView)

  def index(conn, _params) do
    categories = Api.list_categories()
    render(conn, "index.json", categories: categories)
  end
end
