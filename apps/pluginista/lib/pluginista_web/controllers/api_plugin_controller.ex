defmodule PluginistaWeb.ApiPluginController do
    use PluginistaWeb, :controller
  
    alias Pluginista.Api
  
    def index(conn, _params) do
      plugins = Api.list_plugins()
      render(conn, "index.json", plugins: plugins)
    end
end
  