defmodule PluginistaWeb.ApiMakerController do
    use PluginistaWeb, :controller
  
    alias Pluginista.Admin
  
    def index(conn, _params) do
      makers = Admin.list_makers()
      render(conn, "index.json", makers: makers)
    end
end
  