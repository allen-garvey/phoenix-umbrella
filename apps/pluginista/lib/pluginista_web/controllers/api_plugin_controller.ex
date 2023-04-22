defmodule PluginistaWeb.ApiPluginController do
    use PluginistaWeb, :controller
  
    alias Pluginista.Api
  
    def index(conn, _params) do
      plugins = Api.list_plugins()
      render(conn, "index.json", plugins: plugins)
    end

    def plugins_for_maker(conn, %{"id" => id}) do
      plugins = Api.list_plugins_for_maker(id)
      render(conn, "index.json", plugins: plugins)
    end

    def plugins_for_group(conn, %{"id" => id}) do
      plugins = Api.list_plugins_for_group(id)
      render(conn, "index.json", plugins: plugins)
    end

    def plugins_for_category(conn, %{"id" => id}) do
      plugins = Api.list_plugins_for_category(id)
      render(conn, "index.json", plugins: plugins)
    end
end
  